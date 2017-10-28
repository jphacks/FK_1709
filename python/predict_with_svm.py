#coding:utf-8
import MeCab
import json
import glob
from gensim import corpora, models
from sklearn import svm
# grid_search
from sklearn.externals import joblib
import sys


def doc2word_list(doc):

  tagger = MeCab.Tagger('-Ochasen -u ./nlp_resources/st_userdic.dic')
  tagger.parse('')
  node = tagger.parseToNode(doc)

  bow_list = []
  while node:
    meta = node.feature.split(',')
    if meta[0] == '名詞' or meta[6] != '*': # meta[0] == '動詞':
      bow_list.append(meta[6])
    node = node.next

  return bow_list


# def calc_recommend_word(cat_word, test_doc, cat_kw_list):
# 
#   kw_list = []
# 
#   for el in cat_kw_list:
#     if el['category'] == cat_word:
#       kw_list = el['detail_word']

  


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


  test_doc = ''
  with open(sys.argv[1], 'r') as f:
    for line in f:
      test_doc += line.replace('\n', '')
  test_list = doc2word_list(test_doc)

  # BoWで文書をベクトルに変換
  dic = corpora.Dictionary.load_from_text('./svm_resources5/livedoordic.txt')
  bow = [dic.doc2bow(test_list)]
  tfidf_model = models.TfidfModel.load('./svm_resources5/tfidf_model.model')
  tfidf = tfidf_model[bow]
  lsi_model = models.LsiModel.load('./svm_resources5/lsi_model.model')
  lsi = lsi_model[tfidf]

  test_doc = []

  for doc in lsi:
    tmp_list = []
    for doc_tuple in doc:
      tmp_list.append(doc_tuple[1])
    test_doc.append(tmp_list)

  clf = joblib.load('./svm_resources5/svm.pkl.cmp')
  predicted = clf.predict(test_doc)

  # recommend_word_list = calc_recommend_word(label_cat_dict[str(predicted[0])], test_doc, cat_kw_list)

  print('あなたの知り合いは{0}について興味があるかもしれません。'.format(label_cat_dict[str(predicted[0])]))
  print('その中でも特に{0}や{1}、{2}について関心があるかもしれません。'.format('kw1', 'kw2', 'kw3'))
  print('話題に困ったときはぜひご活用ください。')

if __name__ == '__main__':
  main()
