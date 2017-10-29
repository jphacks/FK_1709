#coding:utf-8
import MeCab
import json
import glob
from gensim import corpora, models
from sklearn import svm
# grid_search
from sklearn.externals import joblib
import sys
import numpy as np


def calc_cos_sim(vec1, vec2):

  return np.dot(vec1, vec2) / (np.linalg.norm(vec1) * np.linalg.norm(vec2))


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


def calc_recommend_word(cat_word, test_list, cat_kw_list):

  kw_idx = 0

  for idx in range(len(cat_kw_list)):
    if cat_kw_list[idx]['category'] == cat_word:
      kw_idx = idx
      break

  model = models.Word2Vec.load('./nlp_resources/200-w2v-final.model')

  ave_doc = np.zeros(200)
  word_num = 0

  for word in test_list:
    if not np.isnan(model[word].all()):
      ave_doc += model[word]
      word_num += 1
  ave_doc /= word_num

  recommend_word = {'similarity': calc_cos_sim(ave_doc, model[cat_kw_list[kw_idx]['detail_word'][0]]), 'keyword': cat_kw_list[kw_idx]['detail_word'][0]}

  for idx in range(len(cat_kw_list[kw_idx]['detail_word']) - 1):
    sim = calc_cos_sim(ave_doc,model[cat_kw_list[kw_idx]['detail_word'][idx + 1]])
    if recommend_word['similarity'] < sim:
      recommend_word['similarity'] = sim
      recommend_word['keyword'] = cat_kw_list[kw_idx]['detail_word'][idx + 1]

  return recommend_word['keyword']


def main():

  # カテゴリとキーワードの読み込み
  cat_kw_list = []
  with open('./json/category.json', 'r') as f:
    cat_kw_list = json.load(f)
    for i in range(len(cat_kw_list)):
      cat_kw_list[i]['detail_word'] = cat_kw_list[i]['detail_word'].split(',')

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

  recommend_word = calc_recommend_word(label_cat_dict[str(predicted[0])], test_list, cat_kw_list)

  print('あなたの知り合いは{0}について興味があるかもしれません。'.format(label_cat_dict[str(predicted[0])]))
  print('その中でも特に{0}について関心があるかもしれません。'.format(recommend_word))
  print('話題に困ったときはぜひその話をしてみましょう！')

if __name__ == '__main__':
  main()
