// pattrstorage2minuit.js
// Interface entre pattrstorage et le protocole Minuit
// Karim Barkati - CICM
// Projet ANR Virage - Fevrier 2010
// v.20100223
// Théo de la hogue
// Projet ANR OSSIA - Octobre 2013
// v.20131015

inlets = 1;
outlets = 2;

// my Globals

var mynamespace = "MinuitDevice";
var mynodes = new Array();
var myleaves = new Array();
var out_minuit = 0;
var out_ps = 1;


function from_minuit(chaine)
{
    var leavesRegExp = new RegExp(mynamespace + "/");

    if (chaine.match(/^i-score\?namespace/)) {
        set_namespace(chaine.replace(/^i-score\?namespace /, ""));
    }
    else if (chaine.match(/^i-score\?get/)) {

        set_values(chaine.replace(/^i-score\?get /, ""));
    }
    else { 
        to_pattrstorage(chaine);
    }
}

function from_pattrstorage(chaine)
{
    if (chaine.match(/^clientlist /)) { 
        clientlist(chaine.replace(/^clientlist /, ""));
    }
    else { // data reception
        var reponse = "MinuitDevice:get /" + chaine;
        outlet(out_minuit, reponse);
    }
}

function to_pattrstorage(chaine)
{
    outlet(out_ps, chaine);
}

function set_namespace(chaine)
{
    var rootRegExp = new RegExp("^/" + mynamespace + "$");
    var leavesRegExp = new RegExp("^/");

    if (chaine.match(/^\/$/)) {
        myleaves = [];
        outlet(out_ps, "getclientlist");
    }
    else if ( chaine.match(leavesRegExp) ) // leaves
    {
        outlet(out_minuit, mynamespace + ":namespace " + chaine + " Data attributes={ value service }");
    }
}

function set_values(chaine)
{
    var leavesRegExp = new RegExp("^/");

    if ( chaine.match(leavesRegExp) ) // leaves
    {
        var s = chaine.replace(leavesRegExp, "");
        s = chaine.replace("/", "");
        s = chaine.replace(":value", "");
        outlet(out_ps, "get" + s );
    }
}

function clientlist(param)
{
    if (param == "done") { // ignoring "done" + dump pattrstorage

        var leaves_answer = mynamespace + ":namespace / Application" + " nodes={ " + myleaves + " }";
        outlet(out_minuit, leaves_answer.replace(/\,/g, " "));
    }
    else {
        myleaves.push(param);
    }
}

function top_node_name(chaine)
{
    mynamespace = chaine;
}