#encoding: utf-8
module ApplicationHelper
  def logo
    image_tag 'l1.png',:alt=>"乐哈网,看楼主,脱水吧,脱水工具"
  end

  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
    'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
    'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
    'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
    'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'

  def mobile?
    agent_str = request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad/
      agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end

  def message
    gotonextpage ='无楼主贴 或 未及时采集下来！ 。 请返回<a href="/p/' << params[:p_id] << '">目录页</a> 或按“F5”刷新本页。'
    gotonextpage1 = '无楼主贴！ &nbsp;<span id="spnCount"></span>&nbsp;秒后 自动翻到下一页。 返回<a href="/p/' << params[:p_id] << '">目录页</a>。
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
            else { location.href ="'  <<  (params[:page].to_i + 1).to_s  << '";
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

    if params[:page].to_i.>= (@topic.mypagenum.to_i)
      "本页没有楼主贴，这是最后一页，返回 <a href='/p/#{params[:p_id]}'>目录页</a>。"
    else
      gotonextpage
    end
  end


end
