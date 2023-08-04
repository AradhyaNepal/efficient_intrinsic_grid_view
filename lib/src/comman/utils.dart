//Todo: Make it private
//And make it part of
//Todo: Document
int getCrossAxisCount(int totalItems,int crossAxisItemsCount){
  return (totalItems~/crossAxisItemsCount)+((totalItems%crossAxisItemsCount)==0?0:1);
}