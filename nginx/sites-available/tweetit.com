upstream phpfcgi {
    #server 127.0.0.1:9000;
    server unix:/tmp/php5-fpm.sock; #for PHP-FPM running on UNIX socket
}
server {
    listen 80;

    server_name symfony2;
    root /vagrant/project/web;

    error_log /var/log/nginx/symfony2.error.log;
    access_log /var/log/nginx/symfony2.access.log;

    # strip app.php/ prefix if it is present
    rewrite ^/app\.php/?(.*)$ /$1 permanent;

    location / {
        index app.php;
        try_files $uri @rewriteapp;
    }

    location @rewriteapp {
        rewrite ^(.*)$ /app.php/$1 last;
    }

    # pass the PHP scripts to FastCGI server from upstream phpfcgi
    location ~ ^/(app|app_dev|config)\.php(/|$) {
        fastcgi_pass phpfcgi;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param  HTTPS off;
    }
}