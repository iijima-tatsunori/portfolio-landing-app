/* global $*/
/* global field*/
$(document).on('turbolinks:load', function() {
  // 関数
    // 借方の合計値を求める
    function leftSum(){
      // 表の金額を取得する(偶数列を取得)
      var pricelist = $("input[type='number']:even").map(function(index, val){
        var price = parseInt($(val).val(), 10);
        // 正数のみ入力可能
        var priceMin = parseInt($(val).attr('min'), 10);
        if(price < priceMin){ $(val).val(priceMin); }
        if(isNaN(price)){ $(val).val(''); }
        if(price >= 0) {
          return price;
        } else {
          return null;
        }
      });
      // 価格の合計を求める
      var total = 0;
      pricelist.each(function(index, val){
        total = total + val;
      });
      $('.left-message').text(comma(total) + "円");
    }
    
    // 貸方の合計値を求める
    function rightSum(){
      // 表の金額を取得する(奇数列を取得)
      var pricelist = $("input[type='number']:odd").map(function(index, val){
        var price = parseInt($(val).val(), 10);
        // 正数のみ入力可能
        var priceMin = parseInt($(val).attr('min'), 10);
        if(price < priceMin){ $(val).val(priceMin); }
        if(isNaN(price)){ $(val).val(''); }
        if(price >= 0) {
          return price;
        } else {
          return null;
        }
      });
      // 価格の合計を求める
      var total = 0;
      pricelist.each(function(index, val){
        total = total + val;
      });
      $('.right-message').text(comma(total) + "円");
    }
  
    // 借方金額と貸方金額が違った時にいくら差があるか表示する
    function amountBalance(){
      
      // 表の金額を取得する(偶数列を取得)
      var leftAmount = $("input[type='number']:even").map(function(index, val){
        var leftPrice = parseInt($(val).val(), 10);
        if(leftPrice >= 0) {
          return leftPrice;
        } else {
          return null;
        }
      });
      
      // 表の金額を取得する(奇数列を取得)
      var rightAmount = $("input[type='number']:odd").map(function(index, val){
        var rightPrice = parseInt($(val).val(), 10);
        if(rightPrice >= 0) {
          return rightPrice;
        } else {
          return null;
        }
      });
      
      // 借方金額合計を計算
      var leftBalance = 0;
      leftAmount.each(function(index, val){
        leftBalance = leftBalance + val;
      });
      
      // 貸方金額合計を計算
      var rightBalance = 0;
      rightAmount.each(function(index, val){
        rightBalance = rightBalance + val;
      });
      
      // 借貸の差を計算
      var totalBalance = leftBalance - rightBalance;
      
      $('.caution-balance').text("借貸に" + comma(Math.abs(totalBalance)) + "円の差額があります。");
      
      // 左右金額差が0の時に表示を隠し、送信ボタンを有効にする。
      if (totalBalance == 0) {
        $(".caution-balance").hide();
        $(".submit-btn").prop("disabled", false);
      } else {
        $(".caution-balance").show();
        $(".submit-btn").prop("disabled", true);
      }
    }
    
    // 3桁カンマ区切りとする（小数点も考慮）
    function comma(num) {
      var s = String(num).split('.');
      var ret = String(s[0]).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
      if (s.length > 1) {
          ret += '.' + s[1];
      }
      return ret;
    }
    
    // js-selectable クラスをつけたらSELCT2タグになるようにする
    function init_select2(selector){
      $(selector).select2({
        width: 150,
        allowClear: true,
        placeholder: '未選択',
      });
    }
    
    // イベント
      leftSum();
      rightSum();
      amountBalance();

      // 初期設定フォームの削除ボタンを隠す。
      $(".nestedRemoveClass").hide();
      
      // 子要素でもselect2が効くようにする。
      init_select2(".js-searchable");
      $("form").on("cocoon:after-insert", function(_, row){
        field = $(row).find(".js-searchable");
        init_select2(field);
      });
      
      // 借方金額入力時、借方金額計算処理実行
      $(document).on('keyup click', "input[type='number']:even", function() {
        leftSum();
        amountBalance();
      });
      // 貸方金額入力時、貸方金額計算処理実行
      $(document).on('keyup click', "input[type='number']:odd", function() {
        rightSum();
        amountBalance();
      });
      
      // 削除ボタン押下で貸借金額を再計算
      $(document).on('click', ".nestedRemoveClass", function() {
        // 0.1秒後に再計算
        setTimeout(function(){
  		    leftSum();
          rightSum();
          amountBalance();
  	    },100);
      });
});