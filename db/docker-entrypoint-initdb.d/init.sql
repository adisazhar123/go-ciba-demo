BEGIN;

CREATE TABLE ciba_sessions (
    auth_req_id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    hint VARCHAR(255),
    binding_message VARCHAR(10),
    client_notification_token VARCHAR(255),
    expires_in INT NOT NULL,
    interval INT,
    valid BOOLEAN,
    id_token VARCHAR(2000),
    consented BOOLEAN,
    scope VARCHAR(4000),
    latest_token_requested_at INT,
    created_at TIMESTAMP
);

CREATE TABLE client_applications (
    id VARCHAR(255) PRIMARY KEY,
    secret VARCHAR(255),
    name VARCHAR(255),
    scope VARCHAR(4000),
    token_mode VARCHAR(255),
    client_notification_endpoint VARCHAR(2000),
    authentication_request_signing_alg VARCHAR(10),
    user_code_parameter_supported BOOLEAN,
    redirect_uri VARCHAR(2000),
    token_endpoint_auth_method VARCHAR(20),
    token_endpoint_auth_signing_alg VARCHAR(10),
    grant_types VARCHAR(255),
    public_key_uri VARCHAR(2000)
);

INSERT INTO client_applications (id, secret, name, scope, token_mode, client_notification_endpoint, authentication_request_signing_alg, user_code_parameter_supported, redirect_uri, token_endpoint_auth_method, token_endpoint_auth_signing_alg, grant_types, public_key_uri) VALUES ('2a8c10ed-ca2d-42c6-830a-062b379f5e28', 'cb56645e-a250-4bc9-a716-107347929391', 'Client App 1', 'openid bio timestamp.read', 'poll', '', '', false, '', 'client_secret_basic', '', 'urn:openid:params:grant-type:ciba', '');


CREATE TABLE keys (
    id VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255),
    alg VARCHAR(10),
    public TEXT,
    private TEXT
);

insert into keys (id, client_id, alg, public, private) values ('e2557d15-6f75-449d-a4f5-357f6e294d87', '2a8c10ed-ca2d-42c6-830a-062b379f5e28', 'RS256', '-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqplqy+c2NbSGMuIRU8t8
saD/rpnWPw2JGf7RCw9PYqXK1AIiGbIqN1Gqx6XUNr+xKm0kHc9j4XggDfmCRL58
DzycJnO8Q0D8ViwQ8d5rE3SIoJdFoL/0dK+YoxMVwCt+kqZLgq5ZDBj521SADaeI
3WXyK8W/jIYdnPFqi39/bUXUYBWKmzA2FfA9ucM9idnxKPrXInjelmXd4VnUcXsJ
QgGUpiuSSPHeXCDQiBvdaOLoPr4jR3F6exz39AByK5OkVwKENe9J/tfZSVxkrG81
Ud56/Oal1jWJIiQHqCt7s1hMKInjKFLvQIIdWMchpmfB+Gr67pTthCsFAWMDavKt
+QIDAQAB
-----END PUBLIC KEY-----
', '-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAqplqy+c2NbSGMuIRU8t8saD/rpnWPw2JGf7RCw9PYqXK1AIi
GbIqN1Gqx6XUNr+xKm0kHc9j4XggDfmCRL58DzycJnO8Q0D8ViwQ8d5rE3SIoJdF
oL/0dK+YoxMVwCt+kqZLgq5ZDBj521SADaeI3WXyK8W/jIYdnPFqi39/bUXUYBWK
mzA2FfA9ucM9idnxKPrXInjelmXd4VnUcXsJQgGUpiuSSPHeXCDQiBvdaOLoPr4j
R3F6exz39AByK5OkVwKENe9J/tfZSVxkrG81Ud56/Oal1jWJIiQHqCt7s1hMKInj
KFLvQIIdWMchpmfB+Gr67pTthCsFAWMDavKt+QIDAQABAoIBABVxv3juEWRi0tOm
kyMDWyNA56Lc949pdihsXX6UaBgwWvSXaA3u1VuqylraP3i6U9zPZ1DP9vAql2zq
RjO59gI8TiyPM8UIcC+szlx45uDFLz9whHIWbvYT9I3bIkrLrNdmS+ubWtoocY/e
aVJOEugxnmVeMBvL6AEIX6o1VqE3h1BrAwLbDdP7T+muxJJC3wiXiSxqRe868AzV
c1eKQJjq+BTdV09bcfMTIZ7aNGgI6F1oZ/NLI3UlwnOiLaWCb8aQyaLENwD0AGDw
X5k91OIvogM9cAhlXwidvyW99SuLuWdf/n+FeXueqIf/gnHu7BoFVi2uc3p9r4xK
F6dUJ+ECgYEA13fXqkoCoQZ2sAwM0gTRIXj0XomTmLBGtpil1P+1l7woUKw+sCxO
3oEjEovazEwyOY5bDYPMFqFtR0rNxp2YNPpo8k16XKI+p312p2BAtpbqLEImN/tY
8idZfeClB1XFN8VSAC8OM3w30BHI+aHHMw32gI29ygApvxOWLKiTlWUCgYEAyrDa
4y4fc+ba0rKKCUoCHvJihiXPIuxfMPyVagCrRgr9WB5NNj4c1kKgHwDrwaz2xrtN
OlGAwn9X0i3e6bcfoQ0nRJslQbn66qqfjeNpqK6CEVv9DIgYVajKLDIkWhdQ6+Si
qn5Vq2MU6NIly34XBFoYfQTmRH0R7azdD+TfBwUCgYEArznt8LXJl4x7H0Zdcrqq
HI+SJAO8PZM1nq9bRXJDCsfg/WJmhL0z0q2wiRelczmQKtCDaeVCJzFWfoDuAdUO
AB+ZE1xA426qh2l4Ajw7xIHMpPuSuzo0JpIrrDvx2Zo+DdHxkuaxpNsjRJoCGEkh
h3qWegtLSiiByruyCFV72CUCgYBgepxGBN9N0PYZ0ogn8cVeq6tABWE6U17gN2p7
gYQFHBgJSKsiBaC+UApdl5egoc75O5CAEOmEKw9HaTQw9Uyl4VfurRan2XnZF4xJ
ApV5iE87KhkiTOmgZG6PaPKqu2x2TGctVmM66De8tsLswMD9/lCnuZxNv2a4Rk8X
UK7kbQKBgECFgpN3sDketKz3DUa2oH6eLKHl1c1VWdnCKs7EJySn6p9nTqPg7B3J
8xe6VGuuU0vo2MqHuZJ+Oudpbz9iXpcyij6OcqCxgy8BV+yPV3WZ/LNQ2fJbsQdS
BE6vbTy42rJAxgWLTkaJuDo7UFIpAw361R59n5nTIk5Mxtq3kIxa
-----END RSA PRIVATE KEY-----
');

CREATE TABLE access_tokens (
    access_token VARCHAR(255) PRIMARY KEY,
    client_id VARCHAR(255),
    expires TIMESTAMP,
    user_id VARCHAR(255),
    scope VARCHAR(4000)
);

CREATE TABLE user_accounts (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    user_code VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO user_accounts (id, name, email, password, user_code, created_at, updated_at) VALUES ('133d0f1e-0256-4616-989c-fa569c217355', 'User 123', 'user123.example@email.com', 'password', '12345', now(), now());

CREATE TABLE scopes (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO scopes (id, name) values ('81a10de4-d4ff-4c15-b867-e766c9167a94', 'openid');
INSERT INTO scopes (id, name) values ('ec32bda1-2d18-407e-af55-6f7b5bb7f1fa', 'timestamp.read');

CREATE TABLE claims (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255)
);


INSERT INTO claims(id, name) VALUES ('fc204a63-be8b-463b-81d6-959f4dc0c1df', 'id');
INSERT INTO claims(id, name) VALUES ('10770265-802d-444c-a980-72d228069c20', 'created_at');
INSERT INTO claims(id, name) VALUES ('37b73cb2-e133-421f-b13b-bba1885c64d6', 'updated_at');


CREATE TABLE scope_claims (
    scope_id VARCHAR(255),
    claim_id  VARCHAR(255)
);

INSERT INTO scope_claims(scope_id, claim_id)
VALUES ('ec32bda1-2d18-407e-af55-6f7b5bb7f1fa', '10770265-802d-444c-a980-72d228069c20'),
       ('ec32bda1-2d18-407e-af55-6f7b5bb7f1fa', '37b73cb2-e133-421f-b13b-bba1885c64d6'),
       ('81a10de4-d4ff-4c15-b867-e766c9167a94', 'fc204a63-be8b-463b-81d6-959f4dc0c1df');

COMMIT;