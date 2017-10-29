$(function() {
  $('#jsInputFile button').on('click', function () {
    $('#user_image').click();
    return false;
  });
  
  $('#user_image').on('change', function() {
    //選択したファイル情報を取得し変数に格納
    var file = $(this).prop('files')[0];
    //アイコンを選択中に変更
    $('#jsInputFile').find('.icon').addClass('select').html('選択中');
    //未選択→選択の場合（.filenameが存在しない場合）はファイル名表示用の<div>タグを追加
    if(!($('.filename').length)){
        $('#jsInputFile').append('<div class="filename"></div>');
    };
    $('.filename').html('ファイル名：' + file.name);
  });
  
});
