-- Set "admin" account to administrator rights
insert into user_roles(
    uuid,
    user_uuid,
    role
) values (
     'random-uuid',
    (select uuid from users where login='admin'),
    'admin'
);

-- Set "admin" account to password "admin1"
update
    users
set
    crypted_password='100000$Cnhk9TF+Fgs39ockyvE3Xm2YxMAP14fpJMYGUquBrREJ1dw+v9v9tigL6oDn9y2ypZXbtIU2P0i2WOK7IMnyuQ==',
    salt='TQS6PllWGlJJ+VQVxfWzAEl9Zds=',
    hash_method='PBKDF2',
    reset_password='false',
    user_local='true',
    active='true'
where
    login='admin';
