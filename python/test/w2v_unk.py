from gensim import models
import json

def main():

  model_file = '/hop/home/t_shiota/resources/word2vec_model/200-w2v-final.model'
  # model_file = '/hop/home/t_shiota/resources/word2vec_model/300-w2v-final.model'
  model = models.Word2Vec.load(model_file)

  with open('../json/category.json', 'r') as f:
    cat_kw_list = json.load(f)

  for el in cat_kw_list:
    for word in el['detail_word']:
      print(model[word])


if __name__ == '__main__':
  main()
