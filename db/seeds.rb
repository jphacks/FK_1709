# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users_params = [
  {
    name: '矢野未来',
    email: 'e@a.jp',
    password: '123456 ',
    sex: 'female',
    birthday: '1994-1-30',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '金城英美香',
    email: 't@a.jp',
    password: '123456 ',
    sex: 'female',
    birthday: '1995-10-22',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '若本夏希',
    email: 'a@f.jp',
    password: '123456 ',
    sex: 'female',
    birthday: '1995-3-14',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '上野樹里',
    email: 'a@ea.jp',
    password: '123456 ',
    sex: 'female',
    birthday: '1995-11-18',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '原田藍',
    email: 'a@v.jp',
    password: '123456 ',
    sex: 'female',
    birthday: '1995-12-26',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '前川陽菜',
    email: 'maekawa@pineappear.jp',
    password: '123456',
    sex: 'female',
    birthday: '1995-11-14',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '松原さくら',
    email: 'matsubara@pineappear.jp',
    password: '123456',
    sex: 'female',
    birthday: '1995-11-15',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '金丸芽生',
    email: 'kinmaru@pineappear.jp',
    password: '123456',
    sex: 'female',
    birthday: '1995-11-16',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '榎田葵',
    email: 'enokida@pineappear.jp',
    password: '123456',
    sex: 'female',
    birthday: '1995-11-17',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '坂本結菜',
    email: 'sakamoto@pineappear.jp',
    password: '123456',
    sex: 'female',
    birthday: '1995-11-18',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '松原和真',
    email: 'a@b.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-9-22',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '中川太郎',
    email: 'a@c.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-10-21',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '汐谷宰',
    email: 'a@d.jp',
    password: '123456',
    sex: 'male',
    birthday: '1992-01-02',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '石河和樹',
    email: 'a@g.jp',
    password: '123456',
    sex: 'male',
    birthday: '1989-01-18',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '宮崎航大',
    email: 'a@e.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-10-22',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '安部淳',
    email: 'c@b.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-10-22',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '大西弘樹',
    email: 'c@c.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-10-22',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '福岡雅紀',
    email: 'e@d.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-10-22',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '榎田将吾',
    email: 'f@g.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-10-22',
    married_status: 1,
    job: '学生',
    income: 1
  },{
    name: '久松拓哉',
    email: 'g@e.jp',
    password: '123456',
    sex: 'male',
    birthday: '1995-10-22',
    married_status: 1,
    job: '学生',
    income: 1
  }
]

male_cnt = 1
female_cnt = 1
users_params.each do |params| 
  p params
  if params[:sex] == 'male'
    params[:image] = open "#{Rails.root}/db/seed_files/men#{male_cnt}.jpg"
    User.create(params)    
    male_cnt += 1
  elsif params[:sex] == 'female'
    params[:image] = open "#{Rails.root}/db/seed_files/women#{female_cnt}.jpg"
    User.create(params)    
    female_cnt += 1  
  end
end