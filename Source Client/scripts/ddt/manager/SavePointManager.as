package ddt.manager
{
   import SingleDungeon.event.SingleDungeonEvent;
   import ddt.events.CrazyTankSocketEvent;
   import flash.utils.ByteArray;
   import road7th.comm.PackageIn;
   
   public class SavePointManager
   {
      
      private static var _instance:SavePointManager;
      
      public static var MAX_SAVEPOINT:uint = 128;
      
      public static var SKIP_BASE_SAVEPOINT_LEVEL:uint = 13;
      
      public static var SKIP_ALL_SAVEPOINT_LEVEL:uint = 20;
      
      public static var EXCEPTION_SAVEPOINT:Array = [69,72,28,73,74,75,76,77,78];
       
      
      private var _callBackFun:Function;
      
      private var _savePointArr:Array;
      
      private var _isSkipSavePoint:Boolean = false;
      
      public function SavePointManager()
      {
         super();
         this._savePointArr = new Array();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SAVE_POINTS,this.__receiveSavePointMessage);
      }
      
      public static function get Instance() : SavePointManager
      {
         if(_instance == null)
         {
            _instance = new SavePointManager();
         }
         return _instance;
      }
      
      public function setSavePoint(param1:int) : void
      {
         SocketManager.Instance.out.sendSavePoint(param1);
         this._savePointArr[param1] = true;
      }
      
      public function getSavePoint(param1:int, param2:Function) : void
      {
         this._callBackFun = param2;
         SocketManager.Instance.out.requestSavePoint(param1);
      }
      
      private function __receiveSavePointMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_ = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:ByteArray = new ByteArray();
         _loc2_.readBytes(_loc4_,0,_loc2_.bytesAvailable);
         var _loc5_:Array = new Array();
         _loc5_.push(true);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc3_)
         {
            _loc7_ = _loc6_ % 8;
            _loc8_ = _loc6_ / 8;
            _loc4_.position = _loc8_;
            _loc5_.push(Boolean((_loc4_.readByte() & 1 << _loc7_) > 0));
            _loc6_++;
         }
         _loc4_.position = 0;
         this._callBackFun(_loc5_);
         _loc2_.clear();
         _loc4_.clear();
         _loc2_ = null;
         _loc4_ = null;
      }
      
      public function get savePoints() : Array
      {
         return this._savePointArr;
      }
      
      public function set savePoints(param1:Array) : void
      {
         this._savePointArr = param1;
      }
      
      public function get isSkipSavePoint() : Boolean
      {
         return this._isSkipSavePoint;
      }
      
      public function set isSkipSavePoint(param1:Boolean) : void
      {
         this._isSkipSavePoint = param1;
      }
      
      public function get currentSavePoint() : int
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._savePointArr.length)
         {
            if(!this._savePointArr[_loc1_])
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      public function resetSavePoint(param1:uint) : void
      {
         SocketManager.Instance.out.resetSavePoint(param1);
      }
      
      public function isInSavePoint(param1:int) : Boolean
      {
         switch(param1)
         {
            case 4:
               if(this.savePoints[34] && !this.savePoints[4])
               {
                  return true;
               }
               return false;
               break;
            case 6:
               if(this.savePoints[36] && !this.savePoints[6])
               {
                  return true;
               }
               return false;
               break;
            case 11:
               if(this.savePoints[40] && !this.savePoints[11])
               {
                  return true;
               }
               return false;
               break;
            case 12:
               if(this.savePoints[41] && !this.savePoints[12])
               {
                  return true;
               }
               return false;
               break;
            case 23:
               if(this.savePoints[53] && !this.savePoints[23])
               {
                  return true;
               }
               return false;
               break;
            case 25:
               if(this.savePoints[48] && !this.savePoints[25])
               {
                  return true;
               }
               return false;
               break;
            case 26:
               if(this.savePoints[55] && !this.savePoints[26])
               {
                  return true;
               }
               return false;
               break;
            case 27:
               if(this.savePoints[67] && !this.savePoints[27])
               {
                  return true;
               }
               return false;
               break;
            case 28:
               if(this.savePoints[73] && !this.savePoints[28])
               {
                  return true;
               }
               return false;
               break;
            case 32:
               if(this.savePoints[3] && !this.savePoints[32])
               {
                  return true;
               }
               return false;
               break;
            case 34:
               if(this.savePoints[64] && !this.savePoints[34])
               {
                  return true;
               }
               return false;
               break;
            case 35:
               if(this.savePoints[8] && !this.savePoints[35])
               {
                  return true;
               }
               return false;
               break;
            case 36:
               if(this.savePoints[5] && !this.savePoints[36])
               {
                  return true;
               }
               return false;
               break;
            case 38:
               if(this.savePoints[35] && !this.savePoints[38])
               {
                  return true;
               }
               return false;
               break;
            case 39:
               if(this.savePoints[9] && !this.savePoints[39])
               {
                  return true;
               }
               return false;
               break;
            case 40:
               if(this.savePoints[10] && !this.savePoints[40])
               {
                  return true;
               }
               return false;
               break;
            case 41:
               if(this.savePoints[11] && !this.savePoints[41])
               {
                  return true;
               }
               return false;
               break;
            case 42:
               if(this.savePoints[13] && !this.savePoints[42])
               {
                  return true;
               }
               return false;
               break;
            case 43:
               if(this.savePoints[7] && !this.savePoints[43])
               {
                  return true;
               }
               return false;
               break;
            case 44:
               if(this.savePoints[8] && !this.savePoints[44])
               {
                  return true;
               }
               return false;
               break;
            case 45:
               if(this.savePoints[13] && !this.savePoints[45])
               {
                  return true;
               }
               return false;
               break;
            case 46:
               if(this.savePoints[14] && !this.savePoints[46])
               {
                  return true;
               }
               return false;
               break;
            case 47:
               if(this.savePoints[24] && !this.savePoints[47])
               {
                  return true;
               }
               return false;
               break;
            case 49:
               if(this.savePoints[27] && !this.savePoints[49])
               {
                  return true;
               }
               return false;
               break;
            case 51:
               if(this.savePoints[18] && !this.savePoints[51])
               {
                  return true;
               }
               return false;
               break;
            case 52:
               if(this.savePoints[21] && !this.savePoints[52])
               {
                  return true;
               }
               return false;
               break;
            case 53:
               if(this.savePoints[22] && !this.savePoints[53])
               {
                  return true;
               }
               return false;
               break;
            case 54:
               if(this.savePoints[25] && !this.savePoints[54])
               {
                  return true;
               }
               return false;
               break;
            case 59:
               if(this.savePoints[13] && !this.savePoints[59])
               {
                  return true;
               }
               return false;
               break;
            case 63:
               if(this.savePoints[14] && !this.savePoints[63])
               {
                  return true;
               }
               return false;
               break;
            case 64:
               if(this.savePoints[33] && !this.savePoints[64])
               {
                  return true;
               }
               return false;
               break;
            case 66:
               if(this.savePoints[55] && !this.savePoints[66])
               {
                  return true;
               }
               return false;
               break;
            case 67:
               if(this.savePoints[26] && !this.savePoints[67])
               {
                  return true;
               }
               return false;
               break;
            case 71:
               if(this.savePoints[19] && !this.savePoints[71])
               {
                  return true;
               }
               return false;
               break;
            case 73:
               if(this.savePoints[27] && !this.savePoints[73])
               {
                  return true;
               }
               return false;
               break;
            case 74:
               if(this.savePoints[78] && !this.savePoints[74])
               {
                  return true;
               }
               return false;
               break;
            case 77:
               if(this.savePoints[28] && !this.savePoints[77])
               {
                  return true;
               }
               return false;
               break;
            default:
               if(this.savePoints[param1 - 1] && !this.savePoints[param1])
               {
                  return true;
               }
               return false;
         }
      }
      
      public function syncDungeonSavePoints() : void
      {
         if(TaskManager.instance.isNewHandTaskCompleted(2) && !SavePointManager.Instance.savePoints[4])
         {
            SavePointManager.Instance.setSavePoint(4);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(TaskManager.instance.isNewHandTaskCompleted(5) && !SavePointManager.Instance.savePoints[6])
         {
            SavePointManager.Instance.setSavePoint(6);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(TaskManager.instance.isNewHandTaskCompleted(26) && !SavePointManager.Instance.savePoints[8])
         {
            SavePointManager.Instance.setSavePoint(8);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(TaskManager.instance.isNewHandTaskCompleted(9) && !SavePointManager.Instance.savePoints[12])
         {
            SavePointManager.Instance.setSavePoint(12);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(TaskManager.instance.isNewHandTaskCompleted(16) && !SavePointManager.Instance.savePoints[19])
         {
            SavePointManager.Instance.setSavePoint(19);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
      }
      
      public function checkInSkipSavePoint(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         for each(_loc2_ in SavePointManager.EXCEPTION_SAVEPOINT)
         {
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function syncTaskSavePoints() : void
      {
         if(TaskManager.instance.isNewHandTaskAchieved(1) && !SavePointManager.Instance.savePoints[3])
         {
            SavePointManager.Instance.setSavePoint(3);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(2) && !SavePointManager.Instance.savePoints[5])
         {
            SavePointManager.Instance.setSavePoint(5);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(4) && TaskManager.instance.isNewHandTaskAchieved(5) && !SavePointManager.Instance.savePoints[7])
         {
            SavePointManager.Instance.setSavePoint(7);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(26) && !SavePointManager.Instance.savePoints[35])
         {
            SavePointManager.Instance.setSavePoint(35);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(7) && !SavePointManager.Instance.savePoints[9])
         {
            SavePointManager.Instance.setSavePoint(9);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(6) && !SavePointManager.Instance.savePoints[10])
         {
            SavePointManager.Instance.setSavePoint(10);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(3) && !SavePointManager.Instance.savePoints[11])
         {
            SavePointManager.Instance.setSavePoint(11);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(8) && TaskManager.instance.isNewHandTaskAchieved(9) && !SavePointManager.Instance.savePoints[13])
         {
            SavePointManager.Instance.setSavePoint(13);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(10) && !SavePointManager.Instance.savePoints[14])
         {
            SavePointManager.Instance.setSavePoint(14);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(11) && !SavePointManager.Instance.savePoints[15])
         {
            SavePointManager.Instance.setSavePoint(15);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(12) && !SavePointManager.Instance.savePoints[16])
         {
            SavePointManager.Instance.setSavePoint(16);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(13) && !SavePointManager.Instance.savePoints[17])
         {
            SavePointManager.Instance.setSavePoint(17);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(14) && !SavePointManager.Instance.savePoints[18])
         {
            SavePointManager.Instance.setSavePoint(18);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(15) && TaskManager.instance.isNewHandTaskAchieved(16) && !SavePointManager.Instance.savePoints[20])
         {
            SavePointManager.Instance.setSavePoint(20);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(17) && !SavePointManager.Instance.savePoints[21])
         {
            SavePointManager.Instance.setSavePoint(21);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(18) && !SavePointManager.Instance.savePoints[22])
         {
            SavePointManager.Instance.setSavePoint(22);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(19) && TaskManager.instance.isNewHandTaskAchieved(20) && !SavePointManager.Instance.savePoints[23])
         {
            SavePointManager.Instance.setSavePoint(23);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(21) && !SavePointManager.Instance.savePoints[48])
         {
            SavePointManager.Instance.setSavePoint(48);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(22) && !SavePointManager.Instance.savePoints[25])
         {
            SavePointManager.Instance.setSavePoint(25);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(23) && !SavePointManager.Instance.savePoints[26])
         {
            SavePointManager.Instance.setSavePoint(26);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(27) && !SavePointManager.Instance.savePoints[55])
         {
            SavePointManager.Instance.setSavePoint(55);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(28) && !SavePointManager.Instance.savePoints[67])
         {
            SavePointManager.Instance.setSavePoint(67);
         }
         if(TaskManager.instance.isNewHandTaskAchieved(24) && TaskManager.instance.isNewHandTaskAchieved(25) && !SavePointManager.Instance.savePoints[27])
         {
            SavePointManager.Instance.setSavePoint(27);
         }
      }
   }
}
