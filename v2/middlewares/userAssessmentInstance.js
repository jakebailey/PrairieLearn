var ERR = require('async-stacktrace');
var _ = require('lodash');
var path = require('path');
var logger = require('../logger');
var sqldb = require('../sqldb');
var sqlLoader = require('../sql-loader');

var sql = sqlLoader.loadSqlEquiv(__filename);

module.exports = function(req, res, next) {
    var params = {
        assessment_instance_id: res.locals.assessmentInstanceId ? res.locals.assessmentInstanceId : req.params.assessmentInstanceId,
        user_id: res.locals.user.id,
    };
    sqldb.queryOneRow(sql.all, params, function(err, result) {
        if (ERR(err, next)) return;
        res.locals.assessmentInstance = result.rows[0];
        res.locals.assessmentId = res.locals.assessmentInstance.assessment_id;
        next();
    });
};