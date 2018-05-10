html_dependency_fa <- function() {
  htmltools::htmlDependency("font-awesome", "5.0.12", src = icon_system_file("fonts/font-awesome-5.0.12"),
      stylesheet = "css/fontawesome-all.min.css")
}

## Generate all functions for all icons
#' @rdname fa
#' @export
fa_iconList <- get_iconList(with(html_dependency_fa(), paste0(src$file, "/", stylesheet)))

## Distinguish between icon types (solid and brands)
fab_iconList <- c("500px","accessible-icon","accusoft","adn","adversal","affiliatetheme","algolia","amazon-pay","amazon","amilia","android","angellist","angrycreative","angular","app-store-ios","app-store","apper","apple-pay","apple","asymmetrik","audible","autoprefixer","avianex","aviato","aws","bandcamp","behance-square","behance","bimobject","bitbucket","bitcoin","bity","black-tie","blackberry","blogger-b","blogger","bluetooth-b","bluetooth","btc","buromobelexperte","buysellads","cc-amazon-pay","cc-amex","cc-apple-pay","cc-diners-club","cc-discover","cc-jcb","cc-mastercard","cc-paypal","cc-stripe","cc-visa","centercode","chrome","cloudscale","cloudsmith","cloudversify","codepen","codiepie","connectdevelop","contao","cpanel","creative-commons-by","creative-commons-nc-eu","creative-commons-nc-jp","creative-commons-nc","creative-commons-nd","creative-commons-pd-alt","creative-commons-pd","creative-commons-remix","creative-commons-sa","creative-commons-sampling-plus","creative-commons-sampling","creative-commons-share","creative-commons","css3-alt","css3","cuttlefish","d-and-d","dashcube","delicious","deploydog","deskpro","deviantart","digg","digital-ocean","discord","discourse","dochub","docker","draft2digital","dribbble-square","dribbble","dropbox","drupal","dyalog","earlybirds","ebay","edge","elementor","ember","empire","envira","erlang","ethereum","etsy","expeditedssl","facebook-f","facebook-messenger","facebook-square","facebook","firefox","first-order","firstdraft","flickr","flipboard","fly","font-awesome-alt","font-awesome-flag","font-awesome-logo-full","font-awesome","fonticons-fi","fonticons","fort-awesome-alt","fort-awesome","forumbee","foursquare","free-code-camp","freebsd","get-pocket","gg-circle","gg","git-square","git","github-alt","github-square","github","gitkraken","gitlab","gitter","glide-g","glide","gofore","goodreads-g","goodreads","google-drive","google-play","google-plus-g","google-plus-square","google-plus","google-wallet","google","gratipay","grav","gripfire","grunt","gulp","hacker-news-square","hacker-news","hips","hire-a-helper","hooli","hotjar","houzz","html5","hubspot","imdb","instagram","internet-explorer","ioxhost","itunes-note","itunes","java","jenkins","joget","joomla","js-square","js","jsfiddle","keybase","keycdn","kickstarter-k","kickstarter","korvue","laravel","lastfm-square","lastfm","leanpub","less","line","linkedin-in","linkedin","linode","linux","lyft","magento","mastodon","maxcdn","medapps","medium-m","medium","medrt","meetup","microsoft","mix","mixcloud","mizuni","modx","monero","napster","nintendo-switch","node-js","node","npm","ns8","nutritionix","odnoklassniki-square","odnoklassniki","opencart","openid","opera","optin-monster","osi","page4","pagelines","palfed","patreon","paypal","periscope","phabricator","phoenix-framework","php","pied-piper-alt","pied-piper-hat","pied-piper-pp","pied-piper","pinterest-p","pinterest-square","pinterest","playstation","product-hunt","pushed","python","qq","quinscape","quora","r-project","ravelry","react","readme","rebel","red-river","reddit-alien","reddit-square","reddit","rendact","renren","replyd","researchgate","resolving","rocketchat","rockrms","safari","sass","schlix","scribd","searchengin","sellcast","sellsy","servicestack","shirtsinbulk","simplybuilt","sistrix","skyatlas","skype","slack-hash","slack","slideshare","snapchat-ghost","snapchat-square","snapchat","soundcloud","speakap","spotify","stack-exchange","stack-overflow","staylinked","steam-square","steam-symbol","steam","sticker-mule","strava","stripe-s","stripe","studiovinari","stumbleupon-circle","stumbleupon","superpowers","supple","teamspeak","telegram-plane","telegram","tencent-weibo","themeisle","trello","tripadvisor","tumblr-square","tumblr","twitch","twitter-square","twitter","typo3","uber","uikit","uniregistry","untappd","usb","ussunnah","vaadin","viacoin","viadeo-square","viadeo","viber","vimeo-square","vimeo-v","vimeo","vine","vk","vnv","vuejs","weibo","weixin","whatsapp-square","whatsapp","whmcs","wikipedia-w","windows","wordpress-simple","wordpress","wpbeginner","wpexplorer","wpforms","xbox","xing-square","xing","y-combinator","yahoo","yandex-international","yandex","yelp","yoast","youtube-square","youtube")

#' Font awesome alias
#'
#' @rdname fa-alias
#' @name fa-alias
#' @usage NULL
NULL

#' @evalRd paste("\\keyword{internal}", paste0('\\alias{fa_', gsub('-', '_', fa_iconList), '}'), collapse = '\n')
#' @name fa-alias
#' @rdname fa-alias
#' @exportPattern ^fa_
fa_constructor <- function(...) fa(name = name, ...)
for (icon in fa_iconList) {
  formals(fa_constructor)$name <- icon
  assign(paste0("fa_", gsub("-", "_", icon)), fa_constructor)
}
rm(fa_constructor)


#' Insert icon from font awesome v4.7.0
#'
#' @param name A string indicating the icon name.
#' @param size Size of the icon relative to font size. Options are 1, lg (33%
#' increase), 2, 3, 4, or 5.
#' @param fixed_width If TRUE, the icon is set to a fixed width
#' @param animate 'still', 'spin', or 'pulse'.
#' @param rotate Rotate degree: 0, 90, 180, or 270.
#' @param flip 'none', 'horizontal', 'vertical'.
#' @param border If TRUE, draws a border around the icon.
#' @param pull Pulls icon to either 'left' or 'right' and wraps proceeding text
#' around it.
#' @param other Character vector of other parameters directly added to the icon classes
#'
#' @details `fa_*` is equivalent to `fa(name = *)`, which utilises the auto completion.
#' @references [Font awesome](http://fontawesome.io/icons/)
#'
#' @export
#' @importFrom utils adist
fa <- function(name = "font-awesome", size = 1, fixed_width = FALSE, animate = "still",
    rotate = 0, flip = "none", border = FALSE, pull = NULL, other = NULL, color = NULL, colour = color) {
  if(!(name %in% fa_iconList)){
    stop(paste0("Icon '", name, "' not found in font awesome. Did you mean '", fa_iconList[which.min(adist(name, fa_iconList))], "'?"))
  }
  if (interactive()) {
    print(paste0("fa:", name))
  } else {
    result <- structure(list(name = name, options = list(size = size, fixed_width = fixed_width,
        animate = animate, rotate = rotate, flip = flip, border = border, pull = pull,
        other = other, colour=colour)), class = c("icon_fa", "icon"))
    out <- knitr::knit_print(result)
    class(out) <- c(class(out), "knit_icon")
    out
  }
}

