package consortion.transportSence
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class TransportManager extends EventDispatcher
   {
      
      private static var _instance:TransportManager;
      
      private static const MAX_MESSAGE:uint = 50;
       
      
      private var _transportProposeFrame:TransportProposeFrame;
      
      private var _hijackProposeFrame:TransportHijackProposeFrame;
      
      private var _transportModel:TransportModel;
      
      private var _completeCount:uint = 0;
      
      private var _messageList:Vector.<TransportInfoContent>;
      
      public var currentCar:TransportCar;
      
      public var fightEndBack:Boolean;
      
      public var SelfPoint:Point;
      
      public function TransportManager()
      {
         super();
      }
      
      public static function get Instance() : TransportManager
      {
         if(!TransportManager._instance)
         {
            TransportManager._instance = new TransportManager();
         }
         return TransportManager._instance;
      }
      
      public function setup() : void
      {
         this._messageList = new Vector.<TransportInfoContent>();
         this._transportModel = new TransportModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_TRNSPORT,this.__init);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_MEMBER_INFO,this.__updateMemberInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_CAR_INFO,this.__updateCarInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITE_CONVOY,this.__showPropose);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GEGIN_CONVOY,this.__beginConvoy);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HIJACK_CAR,this.__carIsHijacked);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_CAR,this.__buyCarResult);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HIJACK_INFO_MESSAGE,this.__receiveHijackMessage);
      }
      
      private function __init(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:TransportCar = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_.readByte();
            _loc7_ = new TransportCar(_loc6_);
            _loc7_.info.consortionId = _loc2_.readInt();
            _loc7_.info.consortionName = _loc2_.readUTF();
            _loc7_.info.ownerId = _loc2_.readInt();
            _loc7_.info.ownerName = _loc2_.readUTF();
            _loc7_.info.guarderId = _loc2_.readInt();
            _loc7_.info.guarderName = _loc2_.readUTF();
            _loc7_.info.hijackTimes = _loc2_.readByte();
            _loc7_.info.startDate = _loc2_.readDate();
            _loc7_.info.truckState = _loc2_.readByte();
            _loc7_.info.ownerLevel = _loc2_.readByte();
            _loc7_.speed = _loc2_.readFloat();
            _loc7_.info.lastHijackDate = _loc2_.readDate();
            _loc8_ = _loc2_.readByte();
            if(_loc8_ > 0)
            {
               _loc7_.info.hijackerIdList = new Vector.<int>();
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc7_.info.hijackerIdList.push(_loc2_.readInt());
                  _loc9_++;
               }
            }
            _loc7_.info.speed = _loc7_.speed;
            this._transportModel.addObjects(_loc7_);
            _loc5_++;
         }
         this.SelfPoint = new Point(274,615);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onLoadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onChatBallComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
      }
      
      private function __onLoadingClose(param1:Event = null) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onLoadingClose);
      }
      
      private function __uiProgress(param1:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __updateMemberInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:ConsortiaPlayerInfo = ConsortionModelControl.Instance.model.getConsortiaMemberInfo(_loc3_);
         if(_loc4_)
         {
            _loc4_.ConvoyTimes = _loc2_.readByte();
            _loc4_.GuardTimes = _loc2_.readByte();
            _loc4_.HijackTimes = _loc2_.readByte();
            _loc4_.MaxHijackTimes = _loc2_.readByte();
            _loc4_.MaxConvoyTimes = _loc2_.readByte();
            _loc4_.MaxGuardTimes = _loc2_.readByte();
            _loc4_.GuardTruckId = _loc2_.readInt();
            ConsortionModelControl.Instance.model.updataMember(_loc4_);
            if(_loc4_.ID == PlayerManager.Instance.Self.ID)
            {
               ConsortionModel.REMAIN_CONVOY_TIME = _loc4_.MaxConvoyTimes - _loc4_.ConvoyTimes;
               ConsortionModel.REMAIN_GUARD_TIME = _loc4_.MaxGuardTimes - _loc4_.GuardTimes;
               ConsortionModel.REMAIN_HIJACK_TIME = _loc4_.MaxHijackTimes - _loc4_.HijackTimes;
               dispatchEvent(new ConsortionEvent(ConsortionEvent.UPDATE_MY_INFO));
            }
         }
      }
      
      private function __updateCarInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:uint = 0;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:TransportCarInfo = new TransportCarInfo(_loc3_);
         _loc4_.consortionId = _loc2_.readInt();
         _loc4_.consortionName = _loc2_.readUTF();
         _loc4_.ownerId = _loc2_.readInt();
         _loc4_.ownerName = _loc2_.readUTF();
         _loc4_.guarderId = _loc2_.readInt();
         _loc4_.guarderName = _loc2_.readUTF();
         _loc4_.hijackTimes = _loc2_.readByte();
         _loc4_.startDate = _loc2_.readDate();
         _loc4_.truckState = _loc2_.readByte();
         _loc4_.ownerLevel = _loc2_.readByte();
         _loc4_.speed = _loc2_.readFloat();
         _loc4_.lastHijackDate = _loc2_.readDate();
         var _loc5_:int = _loc2_.readByte();
         if(_loc5_ > 0)
         {
            _loc4_.hijackerIdList = new Vector.<int>();
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc4_.hijackerIdList.push(_loc2_.readInt());
               _loc7_++;
            }
         }
         var _loc6_:TransportCar = this._transportModel.getObjects()[_loc4_.ownerId];
         if(_loc4_.truckState != TransportCarInfo.ISREACHED)
         {
            if(_loc4_.truckState == TransportCarInfo.ISREADY)
            {
               if(_loc4_.guarderId == 0)
               {
                  dispatchEvent(new ConsortionEvent(ConsortionEvent.GUARDER_IS_LEAVING));
               }
            }
            else if(_loc6_)
            {
               _loc4_.speed = _loc6_.speed;
               _loc4_.nickName = _loc6_.nickName;
               _loc6_.info = _loc4_;
            }
            else
            {
               _loc6_ = new TransportCar(_loc3_);
               _loc6_.speed = _loc4_.speed;
               _loc6_.info = _loc4_;
               this._transportModel.addObjects(_loc6_);
               dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_ADD_CAR,_loc6_));
            }
         }
         else
         {
            dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_REMOVE_CAR,_loc6_));
            if(_loc4_.ownerId == PlayerManager.Instance.Self.ID || _loc4_.guarderId == PlayerManager.Instance.Self.ID)
            {
               if(ConsortionModel.REMAIN_CONVOY_TIME > 0)
               {
                  dispatchEvent(new ConsortionEvent(ConsortionEvent.ENABLE_SENDCAR_BTN));
               }
            }
         }
      }
      
      private function __carIsHijacked(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         var _loc6_:int = _loc2_.readByte();
         if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.CONSORTION_TRANSPORT)
         {
            if(this._hijackProposeFrame)
            {
               if(this._hijackProposeFrame.isShowing)
               {
                  return;
               }
            }
            this._hijackProposeFrame = ComponentFactory.Instance.creat("transportSence.TransportHijackProposeFrame");
            this._hijackProposeFrame.setIdAndName(_loc3_,_loc6_,_loc4_,_loc5_);
            this._hijackProposeFrame.addEventListener(Event.CLOSE,this.__transportProposeFrameClose);
            this._hijackProposeFrame.show();
         }
         else
         {
            SocketManager.Instance.out.SendHijackAnswer(_loc3_,_loc4_,_loc5_,false);
         }
      }
      
      private function __beginConvoy(param1:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_CAR_BEGIN_CONVOY));
      }
      
      private function __receiveHijackMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:TransportInfoContent = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:TransportInfoContent = new TransportInfoContent(_loc3_,_loc4_,_loc5_,_loc6_);
         if(this._messageList.length >= MAX_MESSAGE)
         {
            _loc9_ = this._messageList.shift();
            _loc9_.dispose2();
         }
         var _loc8_:String = PlayerManager.Instance.Self.NickName;
         if(_loc3_ == _loc8_ || _loc4_ == _loc8_)
         {
            _loc7_.isMyInfo = true;
         }
         this._messageList.push(_loc7_);
         dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_ADD_MESSAGE,_loc7_));
      }
      
      private function __buyCarResult(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _loc4_ = _loc2_.readByte();
            if(_loc4_ == TransportCar.CARII)
            {
               dispatchEvent(new ConsortionEvent(ConsortionEvent.BUY_HIGH_LEVEL_CAR));
            }
         }
      }
      
      private function __onChatBallComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHAT_BALL)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onChatBallComplete);
            this.loadResFile(this.loadResComplete,PathManager.solveConsortionWalkSceneMapPath("map6"),BaseLoader.MODULE_LOADER);
            this.loadResFile(this.loadLivingComplete,PathManager.solveGameLivingPath("Living239"),BaseLoader.MODULE_LOADER);
            this.loadResFile(this.loadLivingComplete,PathManager.solveGameLivingPath("Living240"),BaseLoader.MODULE_LOADER);
         }
      }
      
      private function loadResFile(param1:Function, param2:String, param3:int) : void
      {
         var _loc4_:BaseLoader = null;
         _loc4_ = LoadResourceManager.instance.createLoader(param2,param3);
         _loc4_.addEventListener(LoaderEvent.COMPLETE,param1);
         _loc4_.addEventListener(LoaderEvent.PROGRESS,this.__uiProgress);
         LoadResourceManager.instance.startLoad(_loc4_);
      }
      
      private function loadLivingComplete(param1:LoaderEvent) : void
      {
      }
      
      private function loadResComplete(param1:LoaderEvent) : void
      {
         this.__onLoadingClose();
         StateManager.setState(StateType.CONSORTION_TRANSPORT);
      }
      
      private function __showPropose(param1:CrazyTankSocketEvent = null) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.CONSORTION_TRANSPORT)
         {
            if(this._transportProposeFrame)
            {
               if(this._transportProposeFrame.isShowing)
               {
                  return;
               }
            }
            this._transportProposeFrame = ComponentFactory.Instance.creat("transportSence.TransportProposeFrame");
            this._transportProposeFrame.setIdAndName(_loc3_,_loc4_);
            this._transportProposeFrame.addEventListener(Event.CLOSE,this.__transportProposeFrameClose);
            this._transportProposeFrame.show();
         }
         else
         {
            SocketManager.Instance.out.SendInviteAnswer(_loc3_,_loc4_,false);
         }
      }
      
      private function __transportProposeFrameClose(param1:Event) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.CLOSE,this.__transportProposeFrameClose);
            _loc2_.dispose();
         }
         _loc2_ = null;
      }
      
      public function get transportModel() : TransportModel
      {
         return this._transportModel;
      }
      
      public function get messageList() : Vector.<TransportInfoContent>
      {
         return this._messageList;
      }
   }
}
