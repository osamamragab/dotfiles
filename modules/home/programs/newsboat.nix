{
    pkgs,
    config,
    ...
}:
{
    programs.newsboat = {
        enable = true;
        package = pkgs.newsboat;
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        maxItems = 0;
        reloadTime = 60; # mins
        reloadThreads = 5;
        autoReload = false;
        autoFetchArticles = {
            enable = false;
            onCalendar = "daily";
        };
        autoVacuum = {
            enable = false;
            onCalendar = "weekly";
        };
        extraConfig = ''
            save-path "${config.xdg.userDirs.download}/newsboat/saved"
            download-path "${config.xdg.userDirs.download}/newsboat/download"

            bind-key h quit
            bind-key k up
            bind-key j down
            bind-key l open
            bind-key k prev articlelist
            bind-key j next articlelist
            bind-key J next-feed articlelist
            bind-key K prev-feed articlelist
            bind-key g home
            bind-key G end
            bind-key ^D pagedown
            bind-key ^U pageup
            bind-key a toggle-article-read
            bind-key n next-unread
            bind-key N prev-unread
            bind-key u show-urls
            bind-key o open-in-browser
            bind-key z pb-download
            bind-key Z pb-toggle-download-all
            bind-key x pb-delete

            color listnormal white default
            color listnormal_unread blue default
            color listfocus white default bold standout
            color listfocus_unread blue default bold standout
            color article white default bold
            color info cyan black bold
        '';
        urls = [
            {
                tags = [
                    "tech"
                    "news"
                    "hackernews"
                    "hnnews"
                ];
                url = "https://news.ycombinator.com/rss";
            }
            {
                tags = [
                    "tech"
                    "news"
                    "hackernews"
                    "hnnews"
                ];
                url = "https://hnrss.org/best";
            }
            {
                tags = [
                    "tech"
                    "news"
                    "hackernews"
                    "hnnews"
                ];
                url = "https://hnrss.org/frontpage";
            }
            {
                tags = [
                    "tech"
                    "news"
                    "lobsters"
                ];
                url = "https://lobste.rs/rss";
            }
            {
                tags = [
                    "linux"
                    "debian"
                ];
                url = "https://www.debian.org/News/news";
            }
            {
                tags = [
                    "linux"
                    "voidlinux"
                ];
                url = "https://voidlinux.org/atom.xml";
            }
            {
                tags = [
                    "linux"
                    "archlinux"
                ];
                url = "https://archlinux.org/feeds/news/";
            }
            {
                tags = [
                    "linux"
                    "suckless"
                ];
                url = "https://suckless.org/atom.xml";
            }
            {
                tags = [
                    "bsd"
                    "freebsd"
                ];
                url = "https://www.freebsd.org/news/feed.xml";
            }
            {
                tags = [
                    "bsd"
                    "bsdnow"
                ];
                url = "https://www.bsdnow.tv/rss";
            }
            {
                tags = [
                    "bsd"
                    "undeadly"
                ];
                url = "https://undeadly.org/cgi?action=rss&full=1";
            }
            {
                tags = [
                    "rfc"
                    "rfc-editor"
                ];
                url = "https://www.rfc-editor.org/rfcatom.xml";
            }
            {
                tags = [
                    "tools"
                    "neovim"
                ];
                url = "http://neovim.io/news.xml";
            }
            {
                tags = [
                    "tech"
                    "news"
                    "hackaday"
                ];
                url = "https://hackaday.com/blog/feed/";
            }
            {
                tags = [
                    "tech"
                    "news"
                    "lxer"
                ];
                url = "https://lxer.com/module/newswire/headlines.rss";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://beej.us/blog/rss.xml";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://unixsheikh.com/feed.rss";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "http://www.aaronsw.com/2002/feeds/pgessays.rss";
            }
            {
                tags = [
                    "blog"
                    "go"
                ];
                url = "https://research.swtch.com/feed.atom";
            }
            {
                tags = [
                    "blog"
                    "rust"
                ];
                url = "https://readrust.net/all/feed.rss";
            }
            {
                tags = [
                    "blog"
                    "rust"
                ];
                url = "https://fasterthanli.me/index.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://without.boats/index.xml";
            }
            {
                tags = [
                    "blog"
                    "rust"
                ];
                url = "https://readrust.net/all/feed.rss";
            }
            {
                tags = [ "blog" ];
                url = "https://drewdevault.com/blog/index.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://jvns.ca/atom.xml";
            }
            {
                tags = [ "blog" ];
                url = "http://ericlippert.com/feed/";
            }
            {
                tags = [ "blog" ];
                url = "https://waldon.blog/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://charity.wtf/feed/";
            }
            {
                tags = [ "blog" ];
                url = "https://macwright.com/atom.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://lethain.com/feeds.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://asthasr.github.io/index.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://desmondrivet.com/posts/feed_lifestream.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://jlelse.blog/posts.rss";
            }
            {
                tags = [ "blog" ];
                url = "https://dellacorte.me/feed.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://2ality.com/feeds/posts.atom";
            }
            {
                tags = [ "blog" ];
                url = "https://waitbutwhy.com/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://pomp.substack.com/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://www.htmhell.dev/feed.xml";
            }
            {
                tags = [
                    "tech"
                    "blog"
                ];
                url = "https://robertmelton.com/index.xml";
            }
            {
                tags = [ "tech" ];
                url = "https://onethingwell.org/rss";
            }
            {
                tags = [
                    "tech"
                    "blog"
                ];
                url = "https://www.computerenhance.com/feed";
            }
            {
                tags = [
                    "tech"
                    "blog"
                ];
                url = "https://www.rfleury.com/feed";
            }
            {
                tags = [
                    "tech"
                    "blog"
                ];
                url = "https://www.developing.dev/feed";
            }
            {
                tags = [
                    "tech"
                    "blog"
                ];
                url = "https://blog.bytebytego.com/feed";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://youssefh.substack.com/feed";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://gomakethings.com/feed/index.xml";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://buttondown.email/cassidoo/rss";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://hasen.substack.com/feed";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://frontendmasters.com/blog/feed";
            }
            {
                tags = [ "tech" ];
                url = "https://golangweekly.com/rss/";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "http://ithare.com/rssfeed/";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://www.openmymind.net/atom.xml";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://www.techhut.tv/rss/";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://chomsky.info/feed/";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://syndication.thedailywtf.com/TheDailyWtf";
            }
            {
                tags = [
                    "blog"
                    "tech"
                ];
                url = "https://stackoverflow.blog/feed/";
            }
            {
                tags = [
                    "blog"
                    "pod"
                    "tech"
                ];
                url = "https://changelog.com/feed";
            }
            {
                tags = [
                    "pod"
                    "tech"
                ];
                url = "https://changelog.com/master/feed";
            }
            {
                tags = [ "ps" ];
                url = "https://projecteuler.net/rss2_euler.xml";
            }
            {
                tags = [
                    "blog"
                    "sci"
                ];
                url = "https://www.johndcook.com/blog/feed";
            }
            {
                tags = [
                    "mag"
                    "sci"
                ];
                url = "https://nautil.us/feed/";
            }
            {
                tags = [ "news" ];
                url = "https://babylonbee.com/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://www.nirandfar.com/feed";
            }
            {
                tags = [
                    "mag"
                    "sci"
                ];
                url = "https://www.nature.com/nature.rss";
            }
            {
                tags = [
                    "blog"
                    "news"
                ];
                url = "https://aaronjacklin.substack.com/feed";
            }
            {
                tags = [
                    "blog"
                    "news"
                ];
                url = "https://graymirror.substack.com/feed";
            }
            {
                tags = [
                    "blog"
                    "news"
                ];
                url = "https://www.malone.news/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://www.astralcodexten.com/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://www.makeworld.space/feed.xml";
            }
            {
                tags = [ "blog" ];
                url = "https://fs.blog/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://markmanson.net/feed";
            }
            {
                tags = [ "blog" ];
                url = "https://adhdftw.com/feed/index.xml";
            }
        ];
    };
}
