<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title><?php if(isset($title)) print $title . " - 知乎日报";else print "知乎日报 - 满足你的好奇心";?></title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <?php
    if($type == 'day')
        print '<link rel="stylesheet" href="/Static/js/bootstrap.min.css">';
    print "<link rel=\"stylesheet\" href=\"/Static/css/{$type}.css\">";
    ?>
    <base target="_self">
</head>
<body class="home">