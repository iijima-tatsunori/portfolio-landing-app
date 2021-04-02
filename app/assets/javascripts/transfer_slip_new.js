$(function(){
    
  // イベント
    // 初期表示用
    leftSum();
    rightSum();
    amountBalance();
    
    // 先頭の削除ボタンを隠す。
    $(".nestedRemoveClass").hide();
    
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
    
    
  
  // 関数
    // 借方の合計値を求める
    function leftSum(){
      // 表の金額を取得する(偶数列を取得)
      var pricelist = $("input[type='number']:even").map(function(index, val){
        var price = parseInt($(val).val());
        // 正数のみ入力可能^
        var priceMin = parseInt($(val).attr('min'));
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
        var price = parseInt($(val).val());
        // 正数のみ入力可能
        var priceMin = parseInt($(val).attr('min'));
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
        var leftPrice = parseInt($(val).val());
        if(leftPrice >= 0) {
          return leftPrice;
        } else {
          return null;
        }
      });
      
      // 表の金額を取得する(奇数列を取得)
      var rightAmount = $("input[type='number']:odd").map(function(index, val){
        var rightPrice = parseInt($(val).val());
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
      var totalBalance = 0;
      var totalBalance = leftBalance - rightBalance;
      
      $('#balance').text("借貸に" + comma(Math.abs(totalBalance)) + "円の差額があります。");
      
      // 左右金額差が0の時に表示を隠し、送信ボタンを有効にする。
      if (totalBalance == 0) {
        $(".caution-balance").hide();
        $(".submit-btn").prop("disabled", false);
      } else {
        $(".caution-balance").show();
        $(".submit-btn").prop("disabled", true);
      }
    }
    
    // 3桁カンマ区切りとする（小数点も考慮）.
    function comma(num) {
      var s = String(num).split('.');
      var ret = String(s[0]).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
      if (s.length > 1) {
          ret += '.' + s[1];
      }
      return ret;
    }
      
  });