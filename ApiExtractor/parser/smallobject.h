/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Copyright (C) 2002-2005 Roberto Raggi <roberto@kdevelop.org>
** Contact: https://www.qt.io/licensing/
**
** This file is part of PySide2.
**
** $QT_BEGIN_LICENSE:GPL-EXCEPT$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/


#ifndef SMALLOBJECT_H
#define SMALLOBJECT_H

#include "rxx_allocator.h"
#include <cstring>

class pool
{
    rxx_allocator<char> __alloc;

public:
    inline void *allocate(std::size_t __size);
    inline void *allocate(std::size_t __size, std::size_t __stride);
};

inline void *pool::allocate(std::size_t __size)
{
    return __alloc.allocate(__size);
}

inline void *pool::allocate(std::size_t __size, std::size_t __stride)
{
  return __alloc.allocate(__size, __stride);
}

#endif

// kate: space-indent on; indent-width 2; replace-tabs on;
