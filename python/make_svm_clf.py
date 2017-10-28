#coding:utf-8
import MeCab
import json
import glob
from gensim import corpora, models
from sklearn import svm, grid_search
from sklearn.externals import joblib


def doc2word_list(doc):

  tagger = MeCab.Tagger('-Ochasen -u ./nlp_resources/st_userdic.dic')
  tagger.parse('')
  node = tagger.parseToNode(doc)

  bow_list = []
  while node:
    meta = node.feature.split(',')
    if meta[0] == '名詞' and meta[6] != '*':  # or meta[0] == '動詞':
      bow_list.append(meta[6])
    node = node.next

  return bow_list


def main():

  # カテゴリとキーワードの読み込み
  cat_kw_list = []
  with open('./json/category.json', 'r') as f:
    cat_kw_list = json.load(f)

  # ラベルとカテゴリの対応
  label_cat_dict = {}
  for idx, el in enumerate(cat_kw_list):
    label_cat_dict.update({str(idx): el['category']})

  # ラベルとディレクトリの対応(スパゲティなので要修正)
  label_dir_dict = {'0': 'sports-watch', '1': 'topic-news', '2': 'it-life-hack', '3': 'movie-enter', '4': 'smax', '5': 'livedoor-homme', '6': 'peachy'}

  # 学習用の文書を格納するリスト
  documents = []
  # 正解ラベルを格納するリスト
  labels = []

  # 学習データの記事から単語リストと正解ラベルのリストを作成する
  for i in range(len(label_dir_dict)):
    print(label_dir_dict[str(i)])
    file_list = sorted(glob.glob('./livedoor-news-data/text/' + label_dir_dict[str(i)] + '/*.txt'))
    for filename in file_list:
      with open(filename, 'r') as f:
        documents.append(doc2word_list(f.readline().replace('\n', '')))
        labels.append(i)

  # BoWで各記事をベクトルに変換
  print('bow')
  dic = corpora.Dictionary(documents)
  dic.filter_extremes(no_below = 20, no_above = 0.3)
  bow_corpus = [dic.doc2bow(d) for d in documents]
  print('+++++ {0} +++++'.format(bow_corpus[0]))
  # 辞書の保存
  dic.save_as_text('./svm_resources5/livedoordic.txt')
  # tf-idfによる単語の重み付け
  print('tf-idf')
  tfidf_model = models.TfidfModel(bow_corpus)
  tfidf_corpus = tfidf_model[bow_corpus]
  print('----- {0} -----'.format(tfidf_corpus[0]))
  # tf-idfモデルの保存
  tfidf_model.save('./svm_resources5/tfidf_model.model')
  # LSIによる次元圧縮
  print('lsi')
  lsi_model = models.LsiModel(tfidf_corpus, id2word = dic, num_topics=300)
  lsi_corpus = lsi_model[tfidf_corpus]
  # lsiモデルの保存
  lsi_model.save('./svm_resources5/lsi_model.model')
  print('finish')

  train_doc = []

  # 文書ベクトルの取得
  for doc in lsi_corpus:
    tmp_list = []
    for doc_tuple in doc:
      tmp_list.append(doc_tuple[1])
    train_doc.append(tmp_list)


  # SVM分類器の実装
  # Grid Search用のパラメータ
  # cs = [0.001, 0.01, 0.1, 1, 10]
  # gammas = [0.001, 0.01, 0.1, 1]
  # parameters = {'kernel': ['rbf'], 'C': cs, 'gamma': gammas}

  # svc = svm.SVC()
  # clf = grid_search.GridSearchCV(svc, parameters)
  clf = svm.SVC(C = 10, gamma = 0.1, kernel = 'rbf')
  clf.fit(train_doc, labels)

  joblib.dump(clf, './svm_resources5/svm.pkl.cmp', compress=True)

  # print('Grid Score: {0}'.format(clf.best_params_))


if __name__ == '__main__':
  main()
