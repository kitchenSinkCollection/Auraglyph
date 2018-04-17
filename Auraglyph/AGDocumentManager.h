//
//  AGDocumentManager.h
//  Auragraph
//
//  Created by Spencer Salazar on 11/17/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#ifndef AGDocumentManager_h
#define AGDocumentManager_h

#include "AGDocument.h"

#include "Geometry.h"

#include <string>
#include <vector>
#include <list>


class AGDocumentManager
{
public:
    
    static AGDocumentManager &instance();
    
    struct DocumentListing
    {
        std::string filename;
        std::vector<std::vector<GLvertex2f>> name;
    };
    
    std::string save(const std::vector<std::vector<GLvertex2f>> &name, const AGDocument &doc);
    void update(const std::string &, const AGDocument &doc);
    AGDocument load(const std::string &);
    const std::vector<DocumentListing> &list();
    const std::vector<DocumentListing> &examplesList();

private:
    
    std::vector<DocumentListing> *m_list;
    std::vector<DocumentListing> *m_examplesList;

    void _loadList(bool force = false);
    std::vector<DocumentListing> *_doLoad(const std::string &dir, const std::string &listFile);
    void _saveList();
};


#endif /* AGDocumentManager_hpp */
