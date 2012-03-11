#encoding: utf-8
module ApplicationHelper
  def message
    gotonextpage = '无楼主贴！ &nbsp;<span id="spnCount"></span>&nbsp;秒后 自动翻到下一页。
        <script type="text/javascript">
        function countdown(_nCount, _oEle) {
            var _oArguments = arguments;
            _oEle.html(_nCount);

            if (_nCount > 0) {
                _nCount--;
                setTimeout(function () {
                    _oArguments.callee(_nCount, _oEle);
                }, 1000);
            }
            else { location.href ="";
            }
        }
        (function () {
            countdown(5, $("#spnCount"));
        })();

    </script>'
    refreshpage = '休息一下眼睛，正在过滤楼主贴。。。！ &nbsp;<span id="spnCount"></span>&nbsp;秒后 自动刷新本页。
        <script type="text/javascript">
        function countdown(_nCount, _oEle) {
            var _oArguments = arguments;
            _oEle.html(_nCount);

            if (_nCount > 0) {
                _nCount--;
                setTimeout(function () {
                    _oArguments.callee(_nCount, _oEle);
                }, 1000);
            }
            else { location.href ="";
            }
        }
        (function () {
            countdown(5, $("#spnCount"));
        })();

    </script>'

  #  if @pagenum.to_i.eql?(@topic.sitepagenum.to_i)
  #    @temp.blank? ? "本页没有楼主贴，这是最后一页。" : refreshpage
  #  else
   #   @temp.blank? ? gotonextpage : refreshpage
   # end
    " meiyou tie"
  end

end
