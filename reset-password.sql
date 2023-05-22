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

-- Reset "admin" account to password "admin" (should be changed on login to "admin1")
update
    users
set
    crypted_password='100000$t2h8AtNs1AlCHuLobDjHQTn9XppwTIx88UjqUm4s8RsfTuXQHSd/fpFexAnewwPsO6jGFQUv/24DnO55hY6Xew==',
    salt='k9x9eN127/3e/hf38iNiKwVfaVk=',
    hash_method='PBKDF2',
    reset_password='true',
    user_local='true',
    active='true'
where
    login='admin';
