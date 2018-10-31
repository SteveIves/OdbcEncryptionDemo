@echo off

rem Create a new root CA certificate request and private key

rem The -nodes option suppresses password protection for the private
rem key, which should never be done in production environments!

echo.
echo Creating root CA certificate request and private key
echo.

openssl req -newkey rsa:2048 -keyout RootCaKey.pem -nodes -out RootCaRequest.pem -config caconfig.cnf

if not exist RootCaRequest.pem (
	echo ERROR: Failed to Create root request
	goto :eof
)

if not exist RootCaKey.pem (
	echo ERROR: Failed to Create root key
	goto :eof
)

rem Sign the request with the private key to create a root CA certificate

echo.
echo Signing root CA certificate
echo.

openssl x509 -req -in RootCaRequest.pem -signkey RootCaKey.pem -out RootCaCertificate.pem -days 3650

if not exist RootCaCertificate.pem (
  echo ERROR: Failed to Create root certificate
  goto :eof
)

rem Concatenate the root certificate and key

copy /y RootCaCertificate.pem + RootCaKey.pem RootCa.pem > nul
