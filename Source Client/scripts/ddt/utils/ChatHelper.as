package ddt.utils
{
   import ddt.view.chat.chat_system;
   import flash.utils.ByteArray;
   
   public class ChatHelper
   {
       
      
      public function ChatHelper()
      {
         super();
      }
      
      chat_system static function readGoodsLinks(param1:ByteArray, param2:Boolean = false) : Array
      {
         var _loc6_:Object = null;
         var _loc3_:Array = [];
         var _loc4_:uint = param1.readUnsignedByte();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Object();
            _loc6_.index = param1.readInt();
            _loc6_.TemplateID = param1.readInt();
            _loc6_.ItemID = param1.readInt();
            if(param2)
            {
               _loc6_.key = param1.readUTF();
            }
            _loc3_.push(_loc6_);
            _loc5_++;
         }
         return _loc3_;
      }
      
      chat_system static function readDungeonInfo(param1:ByteArray) : Object
      {
         var _loc2_:Object = new Object();
         param1.readByte();
         _loc2_.infoIndex = param1.readInt();
         _loc2_.dungeonID = param1.readInt();
         _loc2_.roomID = param1.readInt();
         _loc2_.barrierNum = param1.readInt();
         _loc2_.hardLevel = param1.readInt();
         _loc2_.levelLimit = param1.readInt();
         _loc2_.roompass = param1.readUTF();
         _loc2_.inviterNickName = param1.readUTF();
         return _loc2_;
      }
   }
}
