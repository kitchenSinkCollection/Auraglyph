//
//  AGFileManager.cpp
//  Auragraph
//
//  Created by Spencer Salazar on 1/8/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#include "AGFileManager.h"
#include "NSString+STLString.h"

AGFileManager &AGFileManager::instance()
{
    static AGFileManager s_manager;
    return s_manager;
}

AGFileManager::AGFileManager()
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    m_soundfileDirectory = [documentPath UTF8String];
    m_userDataDirectory = [documentPath UTF8String];
    m_documentDirectory = [documentPath UTF8String];
    m_examplesDirectory = [[[NSBundle mainBundle] pathForResource:@"examples" ofType:@""] stlString];
}

AGFileManager::~AGFileManager()
{ }

const string &AGFileManager::soundfileDirectory()
{
    return m_soundfileDirectory;
}

const string &AGFileManager::userDataDirectory()
{
    return m_userDataDirectory;
}

const string &AGFileManager::documentDirectory()
{
    return m_documentDirectory;
}

const string &AGFileManager::examplesDirectory()
{
    return m_examplesDirectory;
}

bool AGFileManager::fileHasExtension(const string &filepathOrName, const string &extension)
{
    if(filepathOrName.length() == 0 || extension.length() == 0)
        return false;
    const auto pos = filepathOrName.rfind(extension);
    bool hasExtensionAtEnd = (pos == filepathOrName.length()-extension.length());
    bool hasDotBeforeExtension = (pos > 0 && filepathOrName[pos-1] == '.');
    return hasExtensionAtEnd && hasDotBeforeExtension;
}

bool AGFileManager::filenameExists(const string &filename)
{
    std::string filepath = documentDirectory() + "/" + filename;
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithSTLString:filepath]];
}

vector<string> AGFileManager::listDirectory(const string &directory)
{
    vector<string> pathList;
    NSError *error = nil;
    NSArray *pathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithUTF8String:directory.c_str()]
                                                                             error:&error];
    for(NSString *path in pathArray)
    {
        pathList.push_back([path UTF8String]);
    }
    
    return pathList;
}
