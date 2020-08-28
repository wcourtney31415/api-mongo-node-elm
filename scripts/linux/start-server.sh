mkdir server

cd src/elm
sudo elm make src/UserSearch/UserSearch.elm --output=../../server/html/UserSearch.html
sudo elm make src/Login/Login.elm --output=../../server/html/Login.html
sudo elm make src/SignUp/SignUp.elm --output=../../server/html/SignUp.html
cd ..
cd ..
cp src/nodejs/* server/

sudo node server/index.js
