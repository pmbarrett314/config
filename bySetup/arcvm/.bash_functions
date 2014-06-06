
nameterm()
{
echo -n -e "\033]0;$1\007"
}


pulldroid()
{
cd ~/Documents/adt-bundle-linux-x86_64-20130917/workspace/ROSAndroidController/
git checkout $1 -q
git pull -q
back
}

runadt()
{
***REMOVED***
}