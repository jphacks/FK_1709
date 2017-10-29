#coding:utf-8
import glob
import xml.etree.ElementTree as ET


def parse_livedoor_news(doc):

  news_dict = {
    "category": doc.find(".//*[@name='cat']").text,
    "title": doc.find(".//*[@name='title']").text,
    "bodies": [body.text for body in doc.findall(".//*[@name='body']") if body.text]
  }

  return news_dict


def main():

  file_list = sorted(glob.glob('./xml/*.xml'))

  for input_file in file_list:
    dir_path = 'text/' + input_file.split('/')[2].replace('.xml', '')
    print(dir_path)
    tree = ET.parse(input_file)
    root = tree.getroot()

    for doc_num, doc in enumerate(root.findall('doc')):
      output_filename = dir_path + '/doc-' + str(doc_num) + '.txt'
      news = parse_livedoor_news(doc)
      with open(output_filename, 'w') as f:
        f.write(news['title'])
        for el in news['bodies']:
          f.write(el)


if __name__ == '__main__':
  main()
