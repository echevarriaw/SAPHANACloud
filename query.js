'use strict';

var util = require('util');
var waterfall = require('async-waterfall');
var hana = require('@sap/hana-client');

var connOptions = {
    serverNode: '<endpoint>',
	encrypt: 'true',
    uid: '<user>',
    pwd: '<password>'
};

var connection = hana.createConnection();

var tasks = [
	myconn,
    mysql, myexecute, myresults,
    mydisco
	];

waterfall(tasks, done);
console.log("Async calls underway\n");

function myconn(cb) {
    connection.connect(connOptions);
    cb(null);
}

function mysql(cb) {
	var sql = 'SELECT * FROM travel.budgetrooms';
    cb(null, sql);
}

function myexecute(sql, cb) {
    var rows = connection.exec(sql);
    cb(null, rows);
}

function myresults(rows, cb) {
    console.log(util.inspect(rows, { colors: true }));
    console.log("");
    cb(null);
}

function mydisco(cb) {
    connection.disconnect(cb);
}

function done(err) {
    console.log("Async done");
    if (err) {
        return console.error(err);
    }
}
