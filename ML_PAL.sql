connect MYUSER password <password>;

drop view "OzoneRateSorted";
drop table "Params";
drop table "Forecast";
drop table "Statistics";

create view "OzoneRateSorted" as select "Id", "OzoneRate" from MYDATA."OzoneRate" order by "Id" asc;

create column table "Params" ("name" VARCHAR(60), "intArgs" INTEGER, "doubleArgs" DOUBLE, "stringArgs" VARCHAR(100));
insert into "Params" values ('MODELSELECTION', 1, null, null); 
insert into "Params" values ('FORECAST_NUM', 12, null, null); 

call "_SYS_AFL"."PAL_AUTO_EXPSMOOTH" ("OzoneRateSorted", "Params", ?, ?);

create column table "Forecast" ("timeId" INTEGER, "predictedPrice" DOUBLE, "pi1Lower" DOUBLE, "pi1Upper" DOUBLE, "pi2Lower" DOUBLE, "pi2Upper" DOUBLE);
create column table "Statistics" ("name" NVARCHAR(100), "value" NVARCHAR(100));

DO BEGIN     
    in_data = select * from "OzoneRateSorted";
    in_params = select * from "Params";

    "_SYS_AFL"."PAL_AUTO_EXPSMOOTH" (:in_data, :in_params, out_forecast, out_stats);

    insert into "Forecast" select * from :out_forecast;
    insert into "Statistics" select * from :out_stats;
END;

select * from "Forecast";
select * from "Statistics";
