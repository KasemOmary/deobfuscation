#!/usr/bin/perl

use CGI qw (:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI;

$qstring = param('i');
$prod = param('p');
$browser = $ENV{'HTTP_USER_AGENT'};
if ($qstring eq "") { print "Location: $scripturl/redir.cgi?p=$prod\n\n"; exit;}
$cursor = $dbh->prepare("SELECT username,clicks FROM users where username='$qstring'");
$cursor->execute();
($username,$clicks) = $cursor->fetchrow_array;
if ($forceaff eq "Y"){
if ($username ne $qstring) {&error("Affiliate <b>$qstring</b> is not registered with our website.");
}
}
$recipe = "$username|$prod";
$query = new CGI;
if ($browser =~ /MSIE/i) {
$cookie = $query->cookie(-name=>'CBM_COOKIE',
                         -value=>$recipe,
                         -expires=>'+3M',
                         -domain=>$domain,
                         -path=>'/');
}
else {
$cookie = $query->cookie(-name=>'CBM_COOKIE',
                         -value=>$recipe,
                         -expires=>'+3M',
                         -path=>'/');
}
print "Set-cookie: $cookie\n";
       $newclicks = ++$clicks;
$cursor=$dbh->prepare("update users set clicks='$newclicks' where username='$qstring'");
$cursor->execute;
$cursor->finish;
 $dbh->disconnect;
print $query->redirect(-url=>"http://hop.clickbank.net/?$username/$mynick");
exit;
# end of script

