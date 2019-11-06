//
//  ViewController.m
//  增删改查
//
//  Created by 徐金城 on 2019/11/6.
//  Copyright © 2019 xujincheng. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()

@property (nonatomic,assign) sqlite3 *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //db是数据库句柄,就是数据库的象征,要对数据库进行增删改查就要操作这个实例
    sqlite3 *db;
    
    //获取数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"students.sqlite"];
    NSLog(@"%@",filePath);
//Users/xujincheng/Library/Developer/CoreSimulator/Devices/A3BD602E-4365-4B04-9FA4-61186DCE8ADA/data/Containers/Data/Application/6DCB697A-08D1-4C2E-AB13-E64523057459/Documents/students.sqlite
    
    //将OC字符串转成C语言的字符串
    const char *cfilePath = filePath.UTF8String;
    
    //打开数据库文件, 如果数据库文件不存在,这个函数就会自动创建数据库文件
    int result = sqlite3_open(cfilePath, &db);
    if (result == SQLITE_OK) {
        NSLog(@"打开成功");
    } else {
        NSLog(@"打开失败");
    }
    
    const char  *sql="CREATE TABLE IF NOT EXISTS t_students (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
    char *errmsg=NULL;
    result = sqlite3_exec(db, sql, NULL, NULL, &errmsg);
    if (result==SQLITE_OK) {
        NSLog(@"创表成功");
    } else {
        NSLog(@"创表失败");
    }
    
    self.db = db;
}
//增
- (IBAction)insert:(UIButton *)sender {
    for (int i=0; i<20; i++) {
        //1.拼接SQL语句
        NSString *name=[NSString stringWithFormat:@"文晓--%d",arc4random_uniform(100)];
        int age=arc4random_uniform(20)+10;
        NSString *sql=[NSString stringWithFormat:@"INSERT INTO t_students (name,age) VALUES ('%@',%d);",name,age];
        //2.执行SQL语句
        char *errmsg=NULL;
         sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, &errmsg);
         if (errmsg) {//如果有错误信息
             NSLog(@"插入数据失败--%s",errmsg);
         } else {
             NSLog(@"插入数据成功");
         }
     }
}

//删
- (IBAction)delete:(UIButton *)sender {

}

//改
- (IBAction)update:(UIButton *)sender {
    
}

//查
- (IBAction)select:(UIButton *)sender {
     const char *sql="SELECT id,name,age FROM t_students WHERE age<20;";
     sqlite3_stmt *stmt=NULL;
    
     //进行查询前的准备工作
     if (sqlite3_prepare_v2(self.db, sql, -1, &stmt, NULL)==SQLITE_OK) {//SQL语句没有问题
         NSLog(@"查询语句没有问题");

         //每调用一次sqlite3_step函数，stmt就会指向下一条记录
         while (sqlite3_step(stmt)==SQLITE_ROW) {//找到一条记录
             //取出数据
             //(1)取出第0列字段的值（int类型的值）
             int ID=sqlite3_column_int(stmt, 0);
             //(2)取出第1列字段的值（text类型的值）
             const unsigned char *name=sqlite3_column_text(stmt, 1);
             //(3)取出第2列字段的值（int类型的值）
             int age=sqlite3_column_int(stmt, 2);
            // NSLog(@"%d %s %d",ID,name,age);
             printf("%d %s %d\n",ID,name,age);
         }
      } else {
         NSLog(@"查询语句有问题");
      }
}

@end
