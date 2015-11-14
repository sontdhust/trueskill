function resizeLayout() {
    $('.show-content').height(window.innerHeight - 100);
    $('.result').height(window.innerHeight - 100);
    $('.left-menu').height(window.innerHeight - 100);
}

window.onload = function() {
    $('.show-content').height(window.innerHeight - 100);
    $('.result').height(window.innerHeight - 100);
    $('.left-menu').height(window.innerHeight - 100);
};

window.addEventListener('resize', function() {
    $('.show-content').height(window.innerHeight - 100);
    $('.result').height(window.innerHeight - 100);
    $('.left-menu').height(window.innerHeight - 100);
}, true);
