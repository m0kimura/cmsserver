FROM m0kimura/ubuntu-740

EXPOSE 80
EXPOSE 443
ARG user=${user:-docker}
RUN echo "### forever webes ###" \
&&  npm install -g forever
COPY ./parts/master.config /usr/src/master.config
COPY ./parts/Gruntfile.js /usr/src/Gruntfile.js
##
#@module ux-userhead 標準ユーザー環境実行での前処理
ENV HOME=/home/${user} USER=${user}
WORKDIR $HOME
USER $USER
RUN echo '### webes project install ###' \
&&  git clone https://github.com/m0kimura/webes-project.git web-project \
&&  cd web-project \
&&  npm install \
&&  mkdir temp \
&&  cp -r ./repository/. ./temp \
&&  echo '{"presets": ["es2015"]}' > .babelrc \
&&  ./node_modules/.bin/babel ./temp/ -d ./repository/ --presets=env \
&&  rm -rf temp \
&&  mkdir data \
&&  cd ../
##
#@module ux-userfoot 標準ユーザー環境での実行後処理
RUN echo "### ux-userfoot ###" \
&&  echo "export LANG=ja_JP.UTF-8" >> .bashrc
COPY ./starter.sh /usr/bin/starter.sh
ENTRYPOINT ["starter.sh"]
CMD ["none"]