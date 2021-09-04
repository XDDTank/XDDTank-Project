package turnplate
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   
   public class TurnPlateController extends EventDispatcher
   {
      
      private static var _instance:TurnPlateController;
      
      public static const TURNPLATE_HISTORY:uint = 3;
      
      public static const STATE_CHANGE:String = "state_change";
       
      
      private const MAX_MESSAGE:uint = 20;
      
      private var _historyList:Vector.<FilterFrameText>;
      
      private var _view:TurnPlateFrame;
      
      private var _isFrameOpen:Boolean;
      
      private var _isOpen:Boolean;
      
      public function TurnPlateController()
      {
         super();
         this._historyList = new Vector.<FilterFrameText>();
      }
      
      public static function get Instance() : TurnPlateController
      {
         if(!_instance)
         {
            _instance = new TurnPlateController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TURNPLATE_HISTORY_MESSAGE,this.__getRewardMessage);
      }
      
      public function openStatus(param1:PackageIn) : void
      {
         this._isOpen = param1.readBoolean();
         dispatchEvent(new Event(STATE_CHANGE));
      }
      
      private function __getRewardMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:InventoryItemInfo = null;
         var _loc9_:FilterFrameText = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUTF();
            _loc6_ = _loc2_.readUTF();
            _loc7_ = _loc2_.readInt();
            _loc8_ = new InventoryItemInfo();
            _loc8_.TemplateID = _loc7_;
            ItemManager.fill(_loc8_);
            _loc9_ = ComponentFactory.Instance.creatComponentByStylename("turnplate.historyTxt");
            _loc9_.htmlText = LanguageMgr.GetTranslation("ddt.turnplate.historyMessage.txt",_loc5_,_loc6_,_loc8_.Name);
            if(this._historyList.length >= this.MAX_MESSAGE)
            {
               this._historyList.shift();
            }
            if(_loc6_ == PlayerManager.Instance.Self.NickName && ServerManager.Instance.zoneName == _loc5_ && !this._isFrameOpen)
            {
               setTimeout(this.showDelayMessage,8000,_loc9_);
            }
            else
            {
               this._historyList.push(_loc9_);
            }
            _loc4_++;
         }
         if(this._historyList.length > 0)
         {
            if(this._view)
            {
               this._view.addHistoryMessage(this._historyList);
            }
         }
         if(this._isFrameOpen)
         {
            this._isFrameOpen = false;
         }
      }
      
      public function showDelayMessage(param1:FilterFrameText) : void
      {
         this._historyList.push(param1);
         if(this._view)
         {
            this._view.addHistoryMessage(this._historyList);
         }
      }
      
      public function show() : void
      {
         if(!this._isOpen)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.turnplate.notOpen.txt"));
            return;
         }
         this._view = ComponentFactory.Instance.creatCustomObject("turnplate.turnplateFrame");
         this._view.show();
      }
      
      public function hide() : void
      {
         this._view.dispose();
         this._view = null;
      }
      
      public function getBoguCoinCount() : int
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc1_:Array = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(EquipType.BOGU_COIN);
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            _loc2_ += _loc3_.Count;
         }
         return _loc2_;
      }
      
      public function get historyList() : Vector.<FilterFrameText>
      {
         return this._historyList;
      }
      
      public function clearHistoryList() : void
      {
         var _loc1_:FilterFrameText = null;
         for each(_loc1_ in this._historyList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._historyList = new Vector.<FilterFrameText>();
      }
      
      public function forcibleClose() : void
      {
         if(this._view)
         {
            this._view.forcibleClose();
         }
      }
      
      public function set isFrameOpen(param1:Boolean) : void
      {
         this._isFrameOpen = param1;
      }
      
      public function get isShow() : Boolean
      {
         if(this._view)
         {
            return true;
         }
         return false;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
   }
}
