package SingleDungeon.expedition
{
   import SingleDungeon.expedition.msg.FightMsgInfo;
   import SingleDungeon.expedition.view.ExpeditionEvents;
   import SingleDungeon.expedition.view.ExpeditionFrame;
   import SingleDungeon.expedition.view.HardModeExpeditionFrame;
   import SingleDungeon.hardMode.HardModeManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.ExpeditionDataAnalyzer;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.TimeEvents;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class ExpeditionController extends EventDispatcher
   {
      
      private static var _instance:ExpeditionController;
      
      public static const PRE_SCENE:int = 201;
       
      
      private var _model:ExpeditionModel;
      
      private var _expeditionFrame:IExpeditionFrame;
      
      private var _loadXML:Boolean = false;
      
      private var _showStart:Boolean = false;
      
      private var _showStop:Boolean = false;
      
      private var _timerIsRunning:Boolean;
      
      public function ExpeditionController(param1:IEventDispatcher = null)
      {
         super(param1);
         this._model = new ExpeditionModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXPEDITION,this.__socketReponse);
         this.initEvent();
      }
      
      public static function get instance() : ExpeditionController
      {
         if(!_instance)
         {
            _instance = new ExpeditionController();
         }
         return _instance;
      }
      
      public function get model() : ExpeditionModel
      {
         return this._model;
      }
      
      public function get showStart() : Boolean
      {
         return this._showStart;
      }
      
      public function set showStart(param1:Boolean) : void
      {
         this._showStart = param1;
      }
      
      public function get showStop() : Boolean
      {
         return this._showStop;
      }
      
      public function set showStop(param1:Boolean) : void
      {
         this._showStop = param1;
      }
      
      public function setExpeditionInfoDic(param1:ExpeditionDataAnalyzer) : void
      {
         this._model.expeditionInfoDic = param1.list;
      }
      
      public function show(param1:uint) : void
      {
         if(param1 == ExpeditionModel.NORMAL_MODE)
         {
            this._expeditionFrame = ComponentFactory.Instance.creatComponentByStylename("singledungeon.expeditionFrame") as ExpeditionFrame;
         }
         else if(param1 == ExpeditionModel.HARD_MODE)
         {
            this._expeditionFrame = ComponentFactory.Instance.creatComponentByStylename("singledungeon.hardModeExpeditionFrame") as HardModeExpeditionFrame;
         }
         this._expeditionFrame.show();
      }
      
      public function hide() : void
      {
         if(this._expeditionFrame)
         {
            ObjectUtils.disposeObject(this._expeditionFrame);
            this._expeditionFrame = null;
         }
      }
      
      public function sendSocket(param1:int, param2:Array = null) : void
      {
         switch(param1)
         {
            case 1:
               SocketManager.Instance.out.sendExpeditionStart(1,param2["sceneID"],0,param2["count"]);
               break;
            case 2:
               SocketManager.Instance.out.sendExpeditionAccelerate();
               break;
            case 3:
               SocketManager.Instance.out.sendExpeditionCancle();
               break;
            case 4:
               SocketManager.Instance.out.sendExpeditionUpdate();
               break;
            case 5:
               SocketManager.Instance.out.sendExpeditionStart(2,param2[0],param2[1]);
         }
      }
      
      private function __expeditionSecondsHandle(param1:TimeEvents) : void
      {
         var _loc2_:Number = TimeManager.Instance.Now().time;
         var _loc3_:Number = this._model.expeditionEndTime - _loc2_;
         var _loc4_:String = TimeManager.Instance.formatTimeToString1(_loc3_);
         if(_loc4_.slice(_loc4_.length - 2) == "00" || _loc3_ <= 0)
         {
            ExpeditionController.instance.sendSocket(4);
         }
         if(this._expeditionFrame)
         {
            if(_loc3_ > 0)
            {
               this._expeditionFrame.updateRemainTxt(_loc4_);
            }
            else
            {
               this._expeditionFrame.updateRemainTxt("00:00:00");
            }
         }
      }
      
      private function initEvent() : void
      {
         TimeManager.addEventListener(TimeEvents.MINUTES,this.__updateFatigue);
      }
      
      private function __updateFatigue(param1:TimeEvents) : void
      {
         if(this._expeditionFrame)
         {
            this._expeditionFrame.updateFatigue();
         }
      }
      
      private function __socketReponse(param1:ExpeditionEvents) : void
      {
         var _loc12_:Vector.<int> = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Vector.<FightMsgInfo> = null;
         var _loc18_:int = 0;
         var _loc19_:FightMsgInfo = null;
         var _loc2_:String = param1.action;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readByte();
         var _loc5_:Vector.<int> = new Vector.<int>();
         _loc5_.push(_loc3_.readInt());
         _loc5_.push(_loc3_.readInt());
         var _loc6_:Date = _loc3_.readDate();
         var _loc7_:int = _loc3_.readInt();
         var _loc8_:int = _loc3_.readInt();
         var _loc9_:ExpeditionInfo = new ExpeditionInfo();
         _loc9_.ExpeditionType = _loc4_;
         if(_loc4_ == ExpeditionModel.NORMAL_MODE)
         {
            _loc9_.SceneID = _loc5_[0];
         }
         else if(_loc4_ == ExpeditionModel.HARD_MODE)
         {
            _loc12_ = new Vector.<int>();
            _loc13_ = 63;
            while(_loc13_ >= 0)
            {
               _loc14_ = _loc13_ / 32;
               _loc15_ = 1 << _loc13_;
               if((_loc5_[_loc14_] & _loc15_) != 0)
               {
                  _loc12_.push(_loc13_ + PRE_SCENE);
               }
               _loc13_--;
            }
            HardModeManager.instance.hardModeSceneList = _loc12_;
            _loc9_.SceneID = _loc12_[_loc12_.length - 1];
         }
         if(_loc2_ != ExpeditionEvents.STOP)
         {
            _loc9_.IsOnExpedition = _loc4_ == 0 ? Boolean(false) : Boolean(true);
         }
         _loc9_.StartTime = _loc6_;
         PlayerManager.Instance.Self.expeditionCurrent = _loc9_;
         PlayerManager.Instance.Self.expeditionNumCur = _loc8_;
         PlayerManager.Instance.Self.expeditionNumAll = _loc7_;
         var _loc10_:DictionaryData = new DictionaryData();
         var _loc11_:int = 0;
         while(_loc11_ < _loc8_ - 1)
         {
            _loc16_ = _loc3_.readInt();
            _loc17_ = new Vector.<FightMsgInfo>();
            _loc18_ = 0;
            while(_loc18_ < _loc16_)
            {
               _loc19_ = new FightMsgInfo();
               _loc19_.templateID = _loc3_.readInt();
               _loc19_.times = _loc11_ + 1;
               _loc19_.count = _loc3_.readInt();
               _loc17_.push(_loc19_);
               _loc18_++;
            }
            _loc10_.add(_loc11_,_loc17_);
            _loc11_++;
         }
         this._model.getItemsDic = _loc10_;
         this.showStart = true;
         if(_loc2_ != ExpeditionEvents.STOP)
         {
            if((_loc2_ == ExpeditionEvents.START || _loc2_ == ExpeditionEvents.UPDATE) && !this._timerIsRunning)
            {
               this._timerIsRunning = true;
               TimeManager.addEventListener(TimeEvents.SECONDS,this.__expeditionSecondsHandle);
            }
            if(_loc4_ == ExpeditionModel.NORMAL_MODE)
            {
               this._model.expeditionEndTime = _loc9_.StartTime.time + this._model.expeditionInfoDic[_loc9_.SceneID].ExpeditionTime * 60 * 1000 * _loc7_;
            }
            else if(_loc4_ == ExpeditionModel.HARD_MODE)
            {
               this._model.expeditionEndTime = _loc9_.StartTime.time + HardModeManager.instance.getNeedTime();
            }
         }
         else
         {
            TimeManager.removeEventListener(TimeEvents.SECONDS,this.__expeditionSecondsHandle);
            this._timerIsRunning = false;
            this.showStop = true;
         }
         this._model.lastScenceID = _loc9_.SceneID;
         dispatchEvent(new ExpeditionEvents(ExpeditionEvents.UPDATE,_loc2_));
      }
   }
}
