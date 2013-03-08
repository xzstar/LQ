#!/bin/sh

#  update.sh
#  apodang
#
#  Created by Xie Zhe on 13-3-7.
#  Copyright (c) 2013年 科技有限公司. All rights reserved.
echo "updating"

dpkg -i %1

echo "updated"