package ddt.manager
{
   import SingleDungeon.event.SingleDungeonEvent;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.Experience;
   import ddt.data.player.PlayerInfo;
   import ddt.events.DuowanInterfaceEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class GradeExaltClewManager
   {
      
      public static const LIGHT:int = 1;
      
      public static const BLACK:int = 2;
      
      private static var instance:GradeExaltClewManager;
       
      
      private var _asset:MovieClip;
      
      private var _blood:MovieClip;
      
      private var _grade:int;
      
      private var _isSteup:Boolean = false;
      
      private var _character:ShowCharacter;
      
      private var _info:PlayerInfo;
      
      private var _needShowDownloadClient:Boolean;
      
      private var _increBlood:FilterFrameText;
      
      private var _currentNum:int = 0;
      
      private var _targetNum:int = 0;
      
      public function GradeExaltClewManager()
      {
         super();
      }
      
      public static function getInstance() : GradeExaltClewManager
      {
         if(instance == null)
         {
            instance = new GradeExaltClewManager();
         }
         return instance;
      }
      
      public function setup() : void
      {
         if(this._isSteup)
         {
            return;
         }
         this.addEvent();
         this._isSteup = true;
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__GradeExalt);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__GradeExalt);
      }
      
      private function __GradeExalt(param1:PlayerPropertyEvent) : void
      {
         var q:uint = 0;
         var e:PlayerPropertyEvent = param1;
         if(e.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade)
         {
            DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.UP_GRADE));
            if(e.target.Grade == this._grade)
            {
               return;
            }
            this._grade = e.target.Grade;
            if(this._grade >= SavePointManager.SKIP_BASE_SAVEPOINT_LEVEL)
            {
               q = 0;
               while(q <= SavePointManager.MAX_SAVEPOINT)
               {
                  if(!SavePointManager.Instance.checkInSkipSavePoint(q))
                  {
                     SavePointManager.Instance.setSavePoint(q);
                  }
                  q++;
               }
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
               SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
            }
            if(this._grade >= 11)
            {
               this._needShowDownloadClient = true;
            }
            if(!StateManager.isInFight)
            {
               this.show(BLACK);
            }
            else
            {
               CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT,new FunctionAction(function():void
               {
                  show(BLACK);
               }));
            }
         }
      }
      
      public function show(param1:int) : void
      {
         CacheSysManager.lock(CacheConsts.ALERT_IN_MOVIE);
         this.dispose();
         this._asset = ComponentFactory.Instance.creat("asset.core.upgradeClewMcOne");
         this._asset.addEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
         this._asset.addFrameScript(40,this.playeBloodMc);
         this._asset.gotoAndPlay(1);
         this._blood = ComponentFactory.Instance.creat("asset.core.upgradeClewMcNum");
         this._blood.visible = false;
         this._blood.x = 485;
         this._blood.y = 330;
         this._asset.addChild(this._blood);
         this._increBlood = ComponentFactory.Instance.creatComponentByStylename("core.upgradeMoive.text");
         var _loc2_:int = PlayerManager.Instance.Self.Grade;
         if(_loc2_ == 1)
         {
            this._increBlood.text = "100";
         }
         else
         {
            this._increBlood.text = (Experience.getBasicHP(_loc2_) - Experience.getBasicHP(_loc2_ - 1)).toString();
         }
         this._character = CharactoryFactory.createCharacter(PlayerManager.Instance.Self,CharactoryFactory.SHOW,true) as ShowCharacter;
         this._character.showGun = false;
         this._character.setShowLight(false);
         this._character.showWing = false;
         this._character.show(false,1,false);
         this._asset.character.addChild(this._character);
         SoundManager.instance.play("063");
         this._asset.buttonMode = this._asset.mouseChildren = this._asset.mouseEnabled = false;
         if(param1 == LIGHT)
         {
            LayerManager.Instance.addToLayer(this._asset,LayerManager.STAGE_TOP_LAYER,false);
         }
         else
         {
            LayerManager.Instance.addToLayer(this._asset,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         }
         var _loc3_:ChatData = new ChatData();
         _loc3_.msg = LanguageMgr.GetTranslation("tank.manager.GradeExaltClewManager");
         _loc3_.channel = ChatInputView.SYS_NOTICE;
         ChatManager.Instance.chat(_loc3_);
      }
      
      private function playeBloodMc() : void
      {
         this._blood.visible = true;
         this._blood.gotoAndPlay(1);
         this._blood.addEventListener(Event.COMPLETE,this.__bloodCompleteHandler);
      }
      
      private function __bloodFrameHandler(param1:Event) : void
      {
         this.playeAndStopNum(this._currentNum);
         this._currentNum = Math.round(Math.random() * 9) * 100 + Math.round(Math.random() * 9) * 10 + Math.round(Math.random() * 9);
      }
      
      private function __bloodCompleteHandler(param1:Event) : void
      {
         this._blood.stop();
         this._blood.removeEventListener(Event.COMPLETE,this.__bloodCompleteHandler);
         this.playeAndStopNum(int(this._increBlood.text));
      }
      
      private function playeAndStopNum(param1:int) : void
      {
         param1 = Math.abs(param1);
         this.setNum(param1);
      }
      
      private function setNum(param1:int) : void
      {
         param1 = Math.abs(param1);
         var _loc2_:int = param1 % 10000 / 1000;
         var _loc3_:int = param1 % 10000 % 1000 / 100;
         var _loc4_:int = param1 % 10000 % 1000 % 100 / 10;
         var _loc5_:int = param1 % 10000 % 1000 % 100 % 10;
         if(_loc3_ == 0)
         {
            this._blood.num_1.visible = false;
         }
         this._blood.num_1.gotoAndStop(_loc3_ + 1);
         this._blood.num_2.gotoAndStop(_loc4_ + 1);
         this._blood.num_3.gotoAndStop(_loc5_ + 1);
      }
      
      private function end() : void
      {
         this._asset.gotoAndStop(this._asset.totalFrames);
         this.hide();
      }
      
      private function __cartoonFrameHandler(param1:Event) : void
      {
         if(this._asset == null)
         {
            return;
         }
         if(this._asset.currentFrame == this._asset.totalFrames)
         {
            this.end();
            CacheSysManager.unlock(CacheConsts.ALERT_IN_MOVIE);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MOVIE,1000);
         }
      }
      
      private function hide() : void
      {
         this.dispose();
         if(this._grade >= 11)
         {
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.SHOW_DOWNLOAD_FRAME));
         }
      }
      
      private function dispose() : void
      {
         if(this._asset)
         {
            this._asset.removeEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
            ObjectUtils.disposeObject(this._asset);
         }
         this._asset = null;
         if(this._blood)
         {
            this._blood.removeEventListener(Event.COMPLETE,this.__bloodCompleteHandler);
            ObjectUtils.disposeObject(this._blood);
         }
         this._blood = null;
         if(this._increBlood)
         {
            ObjectUtils.disposeObject(this._increBlood);
         }
         this._increBlood = null;
         if(this._character)
         {
            ObjectUtils.disposeObject(this._character);
         }
         this._character = null;
      }
      
      public function get needShowDownloadClient() : Boolean
      {
         return this._needShowDownloadClient;
      }
      
      public function set needShowDownloadClient(param1:Boolean) : void
      {
         this._needShowDownloadClient = param1;
      }
   }
}
