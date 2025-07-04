#!/usr/bin/env node
"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const path_1 = require("path");
const htmldiff_1 = __importDefault(require("./js/htmldiff"));
const argc = process.argv.length;
const cli = (0, path_1.parse)(__filename).name;
let className = null;
let dataPrefix = null;
let atomicTags = null;
function printUsage() {
    const usage = `${cli} v0.9.4

Usage: ${cli} beforeFile afterFile diffedFile [Options]

beforeFile:
  An HTML input file in its original form.

afterFile:
  An HTML input file, based on beforeFile but with changes.

diffedFile:
  Name of the diffed HTML output file. All differences between beforeFile
  and afterFile will be surrounded with <ins> and <del> tags. If diffedFile
  is - (minus) the result will be written with console.log() to stdout.

Options:

-c className (optional):
  className will be added as a class attribute on every <ins> and <del> tag.

-p dataPrefix (optional):
  The data prefix to use for data attributes. The operation index data
  attribute will be named "data-$\{dataPrefix-}operation-index". If not
  used, the default attribute name "data-operation-index" will be added
  on every <ins> and <del> tag. The value of this attribute is an auto
  incremented counter.

-t atomicTags (optional):
  Comma separated list of tag names. The list has to be in the form
  "tag1,tag2,..." e. g. "head,script,style". An atomic tag is one whose
  child nodes should not be compared - the entire tag should be treated
  as one token. This is useful for tags where it does not make sense to
  insert <ins> and <del> tags. If not used, this default list will be used:
  "iframe,object,math,svg,script,video,head,style".`;
    console.log(usage);
}
function readFileContent(fileName) {
    try {
        const result = (0, fs_1.readFileSync)((0, path_1.resolve)(fileName), "utf-8");
        if (result === "") {
            console.error(`File "${fileName}" is empty.`);
        }
        return result;
    }
    catch (error) {
        console.error(`Couldn't read file "${fileName}"\n${error}`);
        return "";
    }
}
function resolveSwitch(name, value) {
    switch (name) {
        case "-c":
            if (className) {
                return false;
            }
            className = value;
            return true;
        case "-p":
            if (dataPrefix) {
                return false;
            }
            dataPrefix = value;
            return true;
        case "-t":
            if (atomicTags) {
                return false;
            }
            atomicTags = value;
            return true;
    }
    return false;
}
const validArgc = [5, 7, 9, 11];
if (validArgc.indexOf(argc) === -1) {
    printUsage();
    process.exit(1);
}
if (argc > 6) {
    if (!resolveSwitch(process.argv[5], process.argv[6])) {
        printUsage();
        process.exit(1);
    }
}
if (argc > 8) {
    if (!resolveSwitch(process.argv[7], process.argv[8])) {
        printUsage();
        process.exit(1);
    }
}
if (argc > 10) {
    if (!resolveSwitch(process.argv[9], process.argv[10])) {
        printUsage();
        process.exit(1);
    }
}
const beforeFile = readFileContent(process.argv[2]);
if (!beforeFile) {
    process.exit(1);
}
const afterFile = readFileContent(process.argv[3]);
if (!afterFile) {
    process.exit(1);
}
const diffedResult = (0, htmldiff_1.default)(beforeFile, afterFile, className, dataPrefix, atomicTags);
if (process.argv[4] === "-") {
    console.log(diffedResult);
}
else {
    (0, fs_1.writeFileSync)((0, path_1.resolve)(process.argv[4]), diffedResult);
}
