-- Update license to specific one (if already exists)
update
    INTERNAL_PROPERTIES
set
    TEXT_VALUE='<license key>',
    IS_EMPTY=false
where
    exists(select * from INTERNAL_PROPERTIES where KEE='sonarsource.license') and KEE='sonarsource.license';

-- Insert license (if not exists)
insert into
    INTERNAL_PROPERTIES (KEE, TEXT_VALUE, IS_EMPTY, CREATED_AT)
select * from (
    select 'sonarsource.license', '<license key>', false, 1682667945827) x
where
    not exists(select * from INTERNAL_PROPERTIES where KEE='sonarsource.license');
