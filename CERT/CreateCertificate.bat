@echo off

rem Create a new private key and self signed certificate request

rem The -nodes option suppresses password protection for the private
rem key, which is required for use with the OpenNet server!

echo.
echo Creating certificate request and private key
echo.

openssl req -newkey rsa:2048 -keyout OpenNetKey.pem -nodes -out OpenNetRequest.pem -config certconfig.cnf

if not exist OpenNetRequest.pem (
	echo ERROR: Failed to create certificate request
	goto :eof
)

if not exist OpenNetKey.pem (
	echo ERROR: Failed to create private key
	goto :eof
)

rem Sign the request with the root CA to create a certificate

echo.
echo Signing certificate
echo.

openssl x509 -req -in OpenNetRequest.pem -CA RootCa.pem -CAkey RootCa.pem -CAcreateserial -out OpenNetCertificate.pem -days 3650

if not exist OpenNetCertificate.pem (
  echo ERROR: Failed to create certificate
  goto :eof
)
