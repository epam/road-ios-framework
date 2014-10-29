$(function() {

    var $tabsComponent = $('.tabsComponent');
    var $tabs = $('.tabs', $tabsComponent);
    var $tabsItems = $('.tab', $tabs);
    var $tabsContent = $('.tabsContent', $tabsComponent);
    var $tabsContentItems = $('.tabContent', $tabsContent);

    $tabsComponent.on('click', '.tab', function() {
        var $tab = $(this);
        var index = $tab.index();

        $tabsItems.add($tabsContentItems).removeClass('active');
        $tab.add($tabsContentItems.eq(index)).addClass('active');
    });

    $tabsComponent.on('click', '.toggler', function() {
        var $toggler = $(this);
        var $tab = $toggler.closest('.tab');
        var $description = $tab.find('.description');
        var $icon = $tab.find('.icon');
        var $neighborTab = $tab.siblings('.tab');
        var $neighborDescription = $neighborTab.find('.description');
        var $neighborIcon = $neighborTab.find('.icon');
        var $neighborType = $neighborTab.find('.code');
        var index = $tab.index();

        $description.toggleClass('active');
        $icon.toggleClass('activeIcon');
        $tab.find('.code').remove();

        if ($description.hasClass('active')) {

            $neighborDescription.removeClass('active');
            $neighborIcon.removeClass('activeIcon');
            $neighborType.remove();

        }


    });






    $tabsComponent.on('click', '.viewCode', function() {

        var $tab = $(this).closest('.tab');
        var index = $tab.index();
        var $description = $tab.find('.description');
        var $code = $tabsContentItems.eq(index).find('code');

        if (($tab.find('.code')).length <= 0) {
            $code.clone().appendTo($tab).show();
        } else {
            $tab.find('.code').remove();
        }


    });



    var $slider = $('.slider');
    var $sliderNav = $('.sliderNav', $slider);
    var $navItems = $('.nav', $sliderNav);
    var $sliderContent = $('.sliderContent', $slider);
    var $navContentItems = $('.navContent', $sliderContent);


    $slider.on('click', '.nav', function() {
        var $nav = $(this);
        var $index = $nav.index();

        $navItems.add($navContentItems).removeClass('active');
        $nav.add($navContentItems.eq($index)).addClass('active');

    });


    function size() {

        var page = $('html').width();

        if (page >= '767') {
            $('.tab').children('.code').remove();

        }
    }


    var $menu = $('.menu');
    var $header = $('header');
    var $headerHeight = $header.height();
    var $headerWidth = $header.width();
    var $menuHeight = $menu.height();
    var mobNav = $('.mobNav');

    $(window).on('resize', function() {
        size();

        $headerHeight = $header.height();

        if ($headerWidth >= '366') {


            if (($(this).scrollTop() >= $headerHeight + $menuHeight)) {

                $menu.addClass('menuBackground');
                $('.menuBlock').css('display', 'inline-block');

            } else {
                if (mobNav.hasClass('show')) {
                    $menu.addClass('menuBackground');
                } else $menu.removeClass('menuBackground');
                $('.menuBlock').css('display', 'none');

            }
        } else {
            console.log('max');
            if (($(this).scrollTop() >= $headerHeight - $menuHeight)) {

                $menu.addClass('menuBackground');
                $('.menuBlock').css('display', 'inline-block');

            } else {
                if (mobNav.hasClass('show')) {
                    $menu.addClass('menuBackground');
                } else $menu.removeClass('menuBackground');
                $('.menuBlock').css('display', 'none');

            }
        }
    });



    $(window).scroll(function() {

        if (($(this).scrollTop() >= $headerHeight - $menuHeight)) {

            $menu.addClass('menuBackground');
            $('.menuBlock').css('display', 'inline-block');

        } else {
            if (mobNav.hasClass('show')) {
                $menu.addClass('menuBackground');
            } else $menu.removeClass('menuBackground');
            $('.menuBlock').css('display', 'none');

        }
    });



    var iconMobMenu = $('.iconMobMenu');

    function propag(event) {
        event.stopPropagation()
    }

    mobNav.on('click', propag);
    iconMobMenu.on('click', propag);

    iconMobMenu.on('click', function(e) {
        mobNav.toggleClass('show');
        iconMobMenu.toggleClass('cross');
        if (iconMobMenu.hasClass('cross')) {
            $('.menu').addClass('menuBackground');
        } else {
            if ($(window).scrollTop() > $headerHeight) {
                $('.menu').addClass('menuBackground');
                console.log('10');
            } else $('.menu').removeClass('menuBackground');

        }


    });


    $(document).on('click', function() {
        mobNav.removeClass('show');
        iconMobMenu.removeClass('cross');

        if ($(window).scrollTop() > $headerHeight) {
            $('.menu').addClass('menuBackground');
        } else $('.menu').removeClass('menuBackground');

    });


    $.getJSON("https://api.github.com/search/repositories?q=road-ios-framework+user:epam", function(data) {

        if (data) {
            $('#gitStarred').text(data.items[0].stargazers_count);
            $('#gitForked').text(data.items[0].forks_count);
        }

    });

});

/*********************************************************************
 *  #### Twitter Post Fetcher v11.0 ####
 *  Coded by Jason Mayes 2013. A present to all the developers out there.
 *  www.jasonmayes.com
 *  Please keep this disclaimer with my code if you use it. Thanks. :-)
 *  Got feedback or questions, ask here:
 *  http://www.jasonmayes.com/projects/twitterApi/
 *  Github: https://github.com/jasonmayes/Twitter-Post-Fetcher
 *  Updates will be posted to this site.
 *********************************************************************/
var twitterFetcher = function() {
    function v(a) {
        return a.replace(/<b[^>]*>(.*?)<\/b>/gi, function(a, f) {
            return f
        }).replace(/class=".*?"|data-query-source=".*?"|dir=".*?"|rel=".*?"/gi, "")
    }

    function l(a, c) {
        for (var f = [], g = new RegExp("(^| )" + c + "( |$)"), b = a.getElementsByTagName("*"), h = 0, e = b.length; h < e; h++) g.test(b[h].className) && f.push(b[h]);
        return f
    }
    var w = "",
        k = 20,
        x = !0,
        m = [],
        q = !1,
        n = !0,
        p = !0,
        r = null,
        s = !0,
        y = !0,
        t = null,
        z = !0;
    return {
        fetch: function(a) {
            void 0 === a.maxTweets && (a.maxTweets = 20);
            void 0 === a.enableLinks && (a.enableLinks = !0);
            void 0 === a.showUser && (a.showUser = !0);
            void 0 === a.showTime && (a.showTime = !0);
            void 0 === a.dateFunction && (a.dateFunction = "default");
            void 0 === a.showRetweet && (a.showRetweet = !0);
            void 0 === a.customCallback && (a.customCallback = null);
            void 0 === a.showInteraction && (a.showInteraction = !0);
            if (q) m.push(a);
            else {
                q = !0;
                w = a.domId;
                k = a.maxTweets;
                x = a.enableLinks;
                p = a.showUser;
                n = a.showTime;
                y = a.showRetweet;
                r = a.dateFunction;
                t = a.customCallback;
                z = a.showInteraction;
                var c = document.createElement("script");
                c.type = "text/javascript";
                c.src = "//cdn.syndication.twimg.com/widgets/timelines/" + a.id + "?&lang=en&callback=twitterFetcher.callback&suppress_response_codes=true&rnd=" + Math.random();
                document.getElementsByTagName("head")[0].appendChild(c)
            }
        },
        callback: function(a) {
            var c = document.createElement("div");
            c.innerHTML = a.body;
            "undefined" === typeof c.getElementsByClassName && (s = !1);
            a = [];
            var f = [],
                g = [],
                b = [],
                h = [],
                e = 0;
            if (s)
                for (c = c.getElementsByClassName("tweet"); e < c.length;) {
                    0 < c[e].getElementsByClassName("retweet-credit").length ? b.push(!0) : b.push(!1);
                    if (!b[e] || b[e] && y) a.push(c[e].getElementsByClassName("e-entry-title")[0]), h.push(c[e].getAttribute("data-tweet-id")), f.push(c[e].getElementsByClassName("p-author")[0]), g.push(c[e].getElementsByClassName("dt-updated")[0]);
                    e++
                } else
                    for (c = l(c, "tweet"); e < c.length;) a.push(l(c[e], "e-entry-title")[0]), h.push(c[e].getAttribute("data-tweet-id")), f.push(l(c[e], "p-author")[0]), g.push(l(c[e], "dt-updated")[0]), 0 < l(c[e], "retweet-credit").length ? b.push(!0) : b.push(!1), e++;
            a.length > k && (a.splice(k, a.length - k), f.splice(k,
                f.length - k), g.splice(k, g.length - k), b.splice(k, b.length - k));
            c = [];
            e = a.length;
            for (b = 0; b < e;) {
                if ("string" !== typeof r) {
                    var d = new Date(g[b].getAttribute("datetime").replace(/-/g, "/").replace("T", " ").split("+")[0]),
                        d = r(d);
                    g[b].setAttribute("aria-label", d);
                    if (a[b].innerText)
                        if (s) g[b].innerText = d;
                        else {
                            var u = document.createElement("p"),
                                A = document.createTextNode(d);
                            u.appendChild(A);
                            u.setAttribute("aria-label", d);
                            g[b] = u
                        } else g[b].textContent = d
                }
                d = "";
                x ? (p && (d += '<div class="user">' + v(f[b].innerHTML) + "</div>"), d +=
                    '<p class="ttt-tweet">' + v(a[b].innerHTML) + '</p>', n && (d += '<p class="timePosted">' + g[b].getAttribute("aria-label") + "</p>")) : a[b].innerText ? (p && (d += '<p class="user">' + f[b].innerText + "</p>"), d += '<span>' + a[b].innerText + "</span>", n && (d += '<p class="timePosted">' + g[b].innerText + "</p>")) : (p && (d += '<p class="user">' + f[b].textContent + "</p>"), d += '<p class="tt-tweet">' + a[b].textContent + '</p>', n && (d += '<p class="timePosted">' + g[b].textContent + "</p>"));
                z && (d += '');
                c.push(d);
                b++
            }
            if (null == t) {
                a = c.length;
                f = 0;
                g = document.getElementById(w);
                for (h = "<ul>"; f < a;) h += "<li>" + c[f] + "</li>", f++;
                g.innerHTML = h + "</ul>"
            } else t(c);
            q = !1;
            0 < m.length && (twitterFetcher.fetch(m[0]), m.splice(0, 1))
        }
    }
}();

var tweetConfig = {
    "id": '496225327811534849',
    "domId": 'tweetLine',
    "maxTweets": 1,
    "enableLinks": false,
    "showUser": true,
    "showTime": false,
    "dateFunction": dateFormatter,
    "showRetweet": false
};

function dateFormatter(date) {
    return date.toTimeString();
}

twitterFetcher.fetch(tweetConfig);