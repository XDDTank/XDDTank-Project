package game.view.settlement
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import game.GameManager;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   
   [Event(name="settleshowed",type="ddt.events.GameEvent")]
   public class SettlementView extends MovieClip implements Disposeable
   {
       
      
      public var goldNum:MovieClip;
      
      public var expNum:MovieClip;
      
      public var VIPAdd:MovieClip;
      
      public var partyAdd:MovieClip;
      
      public var unionAdd:MovieClip;
      
      public var good1:MovieClip;
      
      public var good2:MovieClip;
      
      public var good3:MovieClip;
      
      public var good4:MovieClip;
      
      public var good5:MovieClip;
      
      public var good6:MovieClip;
      
      public var good7:MovieClip;
      
      public var good8:MovieClip;
      
      public var dt1:MovieClip;
      
      public var dt2:MovieClip;
      
      public var goodGrid:MovieClip;
      
      public var continueBtn:SimpleButton;
      
      public var quitBtn:SimpleButton;
      
      public var leftBtn:SimpleButton;
      
      public var rightBtn:SimpleButton;
      
      private const MAXNUM:int = 8;
      
      private var _list:Array;
      
      private var _rect:Rectangle;
      
      private var _expObj:Object;
      
      private var _differTimer:String;
      
      private var _diction:DictionaryData;
      
      private var remainTime:int = 6;
      
      private var intervalId:uint;
      
      private var _dropData:Array;
      
      private var totalPageNum:int;
      
      private var currentPageNum:int;
      
      private var _grade:int;
      
      private var currentGP:int;
      
      private var gpForVIP:int;
      
      private var gpForconsortia:int;
      
      public function SettlementView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._diction = new DictionaryData();
         this._rect = ComponentFactory.Instance.creatCustomObject("settlement.cellRect");
         this._dropData = GameManager.Instance.dropData;
         this.totalPageNum = this._dropData.length / this.MAXNUM;
         this._expObj = GameManager.Instance.Current.selfGamePlayer.expObj;
         this.currentGP = this._expObj.baseExp;
         this.gpForVIP = this._expObj.gpForVIP;
         this.gpForconsortia = this._expObj.consortiaSkill;
         SoundManager.instance.play("063");
      }
      
      private function initEvent() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.showData();
         this.rewardGoods();
         this.check();
      }
      
      private function __continueBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendGameMissionStart(true);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         GameManager.Instance.clearDropData();
      }
      
      protected function __startLoading(param1:Event) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __quitBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(GameManager.Instance.Current.roomType == RoomInfo.SINGLE_DUNGEON)
         {
            SocketManager.Instance.out.sendExitWalkScene();
            StateManager.setState(StateType.SINGLEDUNGEON);
         }
         else if(GameManager.Instance.Current.roomType == RoomInfo.CONSORTION_MONSTER && PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            SocketManager.Instance.out.SendenterConsortion();
         }
         else
         {
            StateManager.setState(StateType.MAIN);
         }
         GameManager.Instance.clearDropData();
      }
      
      private function check() : void
      {
         if(this.currentFrameLabel == "btn")
         {
            if(GameManager.Instance.Current.hasNextMission)
            {
               this.quitBtn.visible = false;
               this.continueBtn.visible = true;
               this.continueBtn.addEventListener(MouseEvent.CLICK,this.__continueBtnClick);
            }
            else
            {
               this.quitBtn.visible = true;
               this.continueBtn.visible = false;
               this.quitBtn.addEventListener(MouseEvent.CLICK,this.__quitBtnClick);
            }
            this.leftBtn.visible = false;
            if(this._dropData.length > this.MAXNUM)
            {
               this.rightBtn.visible = true;
            }
            else
            {
               this.rightBtn.visible = false;
            }
            if(this.dt1)
            {
               this.dt1.gotoAndStop(this.remainTime);
            }
            this.intervalId = setInterval(this.downCount,1000);
         }
         if(this.currentFrame == this.totalFrames)
         {
            stop();
            this.expNum.txt.text = this._expObj.gainGP;
            if(this.goodGrid)
            {
               this.createNextPage(this.goodGrid,0);
               this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this.leftBtn.addEventListener(MouseEvent.CLICK,this.leftRightBtnClick);
               this.rightBtn.addEventListener(MouseEvent.CLICK,this.leftRightBtnClick);
            }
         }
      }
      
      private function createNextPage(param1:MovieClip, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:BaseCell = null;
         var _loc7_:FilterFrameText = null;
         var _loc3_:int = 1;
         while(_loc3_ <= this.MAXNUM)
         {
            if(param1["good" + _loc3_])
            {
               while(param1["good" + _loc3_].numChildren > 0)
               {
                  param1["good" + _loc3_].removeChildAt(0);
               }
               if(_loc3_ <= this._dropData.length - this.MAXNUM * param2)
               {
                  _loc4_ = _loc3_ + this.MAXNUM * param2 - 1;
                  _loc5_ = ItemManager.Instance.getTemplateById(this._dropData[_loc4_].itemId);
                  _loc6_ = new BaseCell(new Sprite(),_loc5_);
                  _loc6_.setContentSize(this._rect.width,this._rect.height);
                  param1["good" + _loc3_].addChild(_loc6_);
                  if(this._dropData[_loc4_].count > 0)
                  {
                     _loc7_ = ComponentFactory.Instance.creatComponentByStylename("settlement.goodsNum");
                     _loc7_.text = this._dropData[_loc4_].count.toString();
                     param1["good" + _loc3_].addChild(_loc7_);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      private function showData() : void
      {
         if(this.goldNum && !this._diction.hasKey(this.goldNum))
         {
            this.goldNum.txt.text = GameManager.Instance.dropGlod.toString();
            this._diction.add(this.goldNum,true);
         }
         if(this.expNum)
         {
            if(this.currentGP <= this._expObj.gainGP)
            {
               this.expNum.txt.text = this.currentGP;
            }
            else
            {
               this.expNum.txt.text = this._expObj.gainGP;
            }
         }
         if(this.VIPAdd && this.gpForVIP > 0)
         {
            if(!this._diction.hasKey(this.VIPAdd))
            {
               this.VIPAdd.play();
               this._diction.add(this.VIPAdd,true);
            }
            this.currentGP += Math.ceil(this.gpForVIP / 100);
            this.gpForVIP -= Math.ceil(this.gpForVIP / 100);
         }
         if(this.unionAdd && this.gpForconsortia > 0)
         {
            if(!this._diction.hasKey(this.unionAdd))
            {
               this.unionAdd.play();
               this._diction.add(this.unionAdd,true);
            }
            this.currentGP += Math.ceil(this.gpForconsortia / 100);
            this.gpForconsortia -= Math.ceil(this.gpForconsortia / 100);
         }
         if(this.partyAdd && 0 != 0)
         {
            this.partyAdd.play();
         }
      }
      
      private function rewardGoods() : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:BaseCell = null;
         var _loc4_:FilterFrameText = null;
         var _loc1_:int = 1;
         while(_loc1_ <= this._dropData.length && _loc1_ <= this.MAXNUM)
         {
            if(this["good" + _loc1_] && this["good" + _loc1_].numChildren == 1)
            {
               _loc2_ = ItemManager.Instance.getTemplateById(this._dropData[_loc1_ - 1].itemId);
               _loc3_ = new BaseCell(new Sprite(),_loc2_);
               _loc3_.setContentSize(this._rect.width,this._rect.height);
               _loc4_ = ComponentFactory.Instance.creatComponentByStylename("settlement.goodsNum");
               _loc4_.text = this._dropData[_loc1_ - 1].count.toString();
               this["good" + _loc1_].addChild(_loc3_);
               this["good" + _loc1_].addChild(_loc4_);
            }
            _loc1_++;
         }
      }
      
      private function leftRightBtnClick(param1:MouseEvent) : void
      {
         if(param1.target == this.leftBtn)
         {
            --this.currentPageNum;
            this.createNextPage(this.goodGrid,this.currentPageNum);
         }
         else if(param1.target == this.rightBtn)
         {
            ++this.currentPageNum;
            this.createNextPage(this.goodGrid,this.currentPageNum);
         }
         if(this.currentPageNum > 0)
         {
            this.leftBtn.visible = true;
         }
         else
         {
            this.leftBtn.visible = false;
         }
         if(this.currentPageNum < this.totalPageNum)
         {
            this.rightBtn.visible = true;
         }
         else
         {
            this.rightBtn.visible = false;
         }
      }
      
      public function updateList(param1:int) : void
      {
         var _loc2_:DungeonInfo = MapManager.getDungeonInfo(param1);
         if(_loc2_)
         {
            this._list = _loc2_.SimpleTemplateIds.split(",");
         }
      }
      
      private function downCount() : void
      {
         --this.remainTime;
         SoundManager.instance.play("048");
         if(this.remainTime >= 0 && this.remainTime < 100)
         {
            if(this.dt1)
            {
               this.dt1.gotoAndStop(int(this.remainTime % 10) + 1);
            }
            if(this.dt2)
            {
               this.dt2.gotoAndStop(int(this.remainTime / 10) + 1);
            }
         }
         if(this.remainTime == 0)
         {
            clearInterval(this.intervalId);
            if(GameManager.Instance.Current.hasNextMission && PlayerManager.Instance.Self.Fatigue >= PlayerManager.Instance.Self.NeedFatigue)
            {
               this.__continueBtnClick(null);
            }
            else
            {
               this.__quitBtnClick(null);
            }
         }
      }
      
      private function removeEvent() : void
      {
         if(this.continueBtn && this.continueBtn.hasEventListener(MouseEvent.CLICK))
         {
            this.continueBtn.removeEventListener(MouseEvent.CLICK,this.__continueBtnClick);
         }
         if(this.quitBtn && this.quitBtn.hasEventListener(MouseEvent.CLICK))
         {
            this.quitBtn.removeEventListener(MouseEvent.CLICK,this.__quitBtnClick);
         }
         if(this.leftBtn && this.leftBtn.hasEventListener(MouseEvent.CLICK))
         {
            this.leftBtn.removeEventListener(MouseEvent.CLICK,this.leftRightBtnClick);
            this.rightBtn.removeEventListener(MouseEvent.CLICK,this.leftRightBtnClick);
         }
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         clearInterval(this.intervalId);
         this._diction.clear();
         this._diction = null;
         this._list = null;
         this._expObj = null;
         this._rect = null;
         this._dropData = null;
         ObjectUtils.disposeObject(this.goodGrid);
         this.goodGrid = null;
         gotoAndStop(1);
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
