//
//  spstring.hpp
//  Auraglyph
//
//  Created by Spencer Salazar on 6/27/18.
//  Copyright © 2018 Spencer Salazar. All rights reserved.
//

#pragma once

#include <string>
#include <vector>

std::vector<std::string> split(const std::string &stringToSplit, char splitBy);

std::string join(const std::vector<std::string> &strings, char joinBy);

std::string pathJoin(const std::vector<std::string> &strings);

