/**
 * Created by JetBrains RubyMine.
 * User: Administrator
 * Date: 12-5-15
 * Time: 下午3:06
 * To change this template use File | Settings | File Templates.
 */
        $(document).ready(function () {
            $(".addcollect").click(function () {
                var ctrl = (navigator.userAgent.toLowerCase()).indexOf('mac') != -1 ? 'Command/Cmd' : 'CTRL';
                if (document.all) {
                    window.external.addFavorite('http://www.lehazi.com/', '乐哈子-阅读热贴的好工具');
                } else if (window.sidebar) {
                    window.sidebar.addPanel('乐哈子-阅读热贴的好工具', 'http://www.lehazi.com/', "")
                } else {
                    alert('您可以尝试通过快捷键' + ctrl + ' + D 加入到收藏夹~')
                }
            })
        });
