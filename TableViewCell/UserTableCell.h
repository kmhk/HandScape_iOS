//
//  UserTableCell.h
//  Chat
//
//  Created by Nikolay Petrovich on 4/12/16.
//  Copyright © 2016 handscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* m_ivPic;
@property (weak, nonatomic) IBOutlet UILabel* m_lblName;
@property (weak, nonatomic) IBOutlet UILabel* m_lblEmail;

@end
