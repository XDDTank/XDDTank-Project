package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ChatBugleView extends Sprite
   {
      
      private static const BIG_BUGLE:uint = 1;
      
      private static const SMALL_BUGLE:uint = 2;
      
      private static const ADMIN_NOTICE:uint = 3;
      
      private static const DEFY_AFFICHE:uint = 3;
      
      private static const CROSS_BUGLE:uint = 4;
      
      private static const CROSS_NOTICE:uint = 5;
      
      private static const MOVE_STEP:uint = 3;
      
      private static var _instance:ChatBugleView;
       
      
      private var _scrollTimer:Timer;
      
      private var _showTimer:Timer;
      
      private var _timer:Timer;
      
      private var _isplaying:Boolean;
      
      private var _bugleList:Array;
      
      private var _currentBugle:String;
      
      private var _currentBugleType:int;
      
      private var _currentBigBugleType:int;
      
      private var _buggleTypeMc:ScaleFrameImage;
      
      private var _bg:Bitmap;
      
      private var _bgMask:Bitmap;
      
      private var _bgMask1:Bitmap;
      
      private var _contentTxt:FilterFrameText;
      
      private var _contentTxt1:FilterFrameText;
      
      private var _animationTxt:FilterFrameText;
      
      private var _textCount:int;
      
      private var _bigBugleAnimations:Vector.<MovieClip>;
      
      public function ChatBugleView()
      {
         super();
      }
      
      public static function get instance() : ChatBugleView
      {
         if(_instance == null)
         {
            _instance = new ChatBugleView();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._bigBugleAnimations = new Vector.<MovieClip>(5);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
         this._bgMask = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
         this._bgMask1 = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
         this._buggleTypeMc = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewType");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewText");
         this._contentTxt1 = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewText");
         this._animationTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleAnimationText");
         this._showTimer = new Timer(8000);
         PositionUtils.setPos(this,"chat.BugleViewPos");
         this._isplaying = false;
         this._bugleList = [];
         this._currentBugleType = -1;
         addChild(this._bg);
         addChild(this._bgMask);
         addChild(this._bgMask1);
         this._bgMask.visible = false;
         this._bgMask1.visible = false;
         addChild(this._buggleTypeMc);
         addChild(this._contentTxt);
         mouseEnabled = mouseChildren = false;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__onAddChat);
      }
      
      private function __onAddChat(param1:ChatEvent) : void
      {
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:ItemTemplateInfo = null;
         var _loc14_:uint = 0;
         if(ChatManager.Instance.state == ChatManager.CHAT_WEDDINGROOM_STATE || ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW || ChatManager.Instance.state == ChatManager.CHAT_TRAINER_STATE || ChatManager.Instance.state == ChatManager.CHAT_LITTLEGAME || ChatManager.Instance.isInGame)
         {
            return;
         }
         var _loc2_:ChatData = param1.data as ChatData;
         var _loc3_:String = "";
         var _loc4_:RegExp = /&lt;/g;
         var _loc5_:RegExp = /&gt;/g;
         var _loc6_:String = _loc2_.msg.replace(_loc4_,"<").replace(_loc5_,">");
         _loc6_ = Helpers.deCodeString(_loc6_);
         if(_loc2_.link)
         {
            _loc9_ = 0;
            _loc2_.link.sortOn("index");
            for each(_loc10_ in _loc2_.link)
            {
               _loc11_ = _loc10_.ItemID;
               _loc12_ = _loc10_.TemplateID;
               _loc13_ = ItemManager.Instance.getTemplateById(_loc12_);
               _loc14_ = _loc10_.index + _loc9_;
               if(_loc13_ == null)
               {
                  if(_loc12_ == 0)
                  {
                     _loc6_ = _loc6_.substring(0,_loc14_) + "[" + LanguageMgr.GetTranslation("tank.view.card.chatLinkText0") + "]" + _loc6_.substring(_loc14_);
                     _loc9_ += LanguageMgr.GetTranslation("tank.view.card.chatLinkText0").length;
                  }
                  else
                  {
                     _loc6_ = _loc6_.substring(0,_loc14_) + "[" + String(_loc12_) + LanguageMgr.GetTranslation("tank.view.card.chatLinkText") + "]" + _loc6_.substring(_loc14_);
                     _loc9_ += (String(_loc12_) + LanguageMgr.GetTranslation("tank.view.card.chatLinkText")).length;
                  }
               }
               else
               {
                  _loc6_ = _loc6_.substring(0,_loc14_) + "[" + _loc13_.Name + "]" + _loc6_.substring(_loc14_);
                  _loc9_ += _loc13_.Name.length;
               }
            }
         }
         var _loc7_:int = BIG_BUGLE;
         var _loc8_:int = ChatData.B_BUGGLE_TYPE_NORMAL;
         if(_loc2_.channel == ChatInputView.SMALL_BUGLE)
         {
            _loc7_ = SMALL_BUGLE;
            _loc3_ = "[" + _loc2_.sender + "]:" + _loc6_;
         }
         else if(_loc2_.channel == ChatInputView.BIG_BUGLE)
         {
            _loc7_ = BIG_BUGLE;
            if(_loc2_.bigBuggleType != ChatData.B_BUGGLE_TYPE_NORMAL)
            {
               _loc8_ = _loc2_.bigBuggleType;
               _loc3_ = "[" + _loc2_.sender + "]:" + _loc6_;
            }
            else
            {
               _loc8_ = ChatData.B_BUGGLE_TYPE_NORMAL;
               _loc3_ = "[" + _loc2_.sender + "]:" + _loc6_;
            }
         }
         else if(_loc2_.channel == ChatInputView.CROSS_BUGLE)
         {
            _loc7_ = CROSS_BUGLE;
            _loc3_ = "[" + _loc2_.sender + "]:" + _loc6_;
         }
         else if(_loc2_.channel == ChatInputView.CROSS_NOTICE)
         {
            _loc7_ = ADMIN_NOTICE;
            _loc3_ = _loc6_;
         }
         else if(_loc2_.channel == ChatInputView.DEFY_AFFICHE)
         {
            _loc7_ = DEFY_AFFICHE;
            _loc3_ = _loc6_;
         }
         else
         {
            if(!(_loc2_.channel == ChatInputView.SYS_NOTICE || _loc2_.channel == ChatInputView.SYS_TIP))
            {
               return;
            }
            if(!(_loc2_.type == 1 || _loc2_.type == 3 || _loc2_.type == 9 || _loc2_.type == 5 || _loc2_.type == 21 || _loc2_.type == 4 || _loc2_.type == 16 || _loc2_.type == 6))
            {
               return;
            }
            _loc7_ = ADMIN_NOTICE;
            _loc3_ = _loc6_;
         }
         this._bugleList.push(new ChatBugleData(_loc3_,_loc7_,_loc8_));
         this.checkPlay();
      }
      
      private function __showTimer(param1:TimerEvent) : void
      {
         this._isplaying = false;
         this._showTimer.stop();
         this._showTimer.removeEventListener(TimerEvent.TIMER,this.__showTimer);
         this.checkPlay();
      }
      
      private function checkPlay() : void
      {
         var _loc1_:ChatBugleData = null;
         if(PlayerManager.Instance.Self.Grade > 1)
         {
            if(this._isplaying)
            {
               return;
            }
            if(this._bugleList.length > 0)
            {
               if(this._bugleList.length > 10)
               {
                  this._bugleList.splice(0,this._bugleList.length - 10);
               }
               _loc1_ = this._bugleList.splice(0,1)[0];
               this._currentBugle = _loc1_.content;
               this._currentBugleType = _loc1_.BugleType;
               this._currentBigBugleType = _loc1_.subBugleType;
               if(this._animationTxt.parent)
               {
                  this._animationTxt.parent.removeChild(this._animationTxt);
               }
               this.removeAllBuggleAnimations();
               this._buggleTypeMc.setFrame(this._currentBugleType);
               addChild(this._bg);
               addChild(this._buggleTypeMc);
               addChild(this._contentTxt);
               if(this._currentBugleType == BIG_BUGLE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.BIG_BUGLE);
                  if(this._currentBigBugleType != ChatData.B_BUGGLE_TYPE_NORMAL)
                  {
                     if(this._contentTxt.parent)
                     {
                        this._contentTxt.parent.removeChild(this._contentTxt);
                     }
                     if(this._buggleTypeMc.parent)
                     {
                        this._buggleTypeMc.parent.removeChild(this._buggleTypeMc);
                     }
                     if(this._bg.parent)
                     {
                        this._bg.parent.removeChild(this._bg);
                     }
                     this._animationTxt.textColor = ChatFormats.getColorByBigBuggleType(this._currentBigBugleType - 1);
                     if(this._bigBugleAnimations[this._currentBigBugleType - 1] == null)
                     {
                        this._bigBugleAnimations[this._currentBigBugleType - 1] = ComponentFactory.Instance.creat("chat.BugleAnimation_" + (this._currentBigBugleType - 1).toString());
                        PositionUtils.setPos(this._bigBugleAnimations[this._currentBigBugleType - 1],"chat.BugleAnimationPos_" + (this._currentBigBugleType - 1).toString());
                     }
                     this._animationTxt.x = this._bigBugleAnimations[this._currentBigBugleType - 1].x;
                     this._animationTxt.y = this._bigBugleAnimations[this._currentBigBugleType - 1].y;
                     this._bigBugleAnimations[this._currentBigBugleType - 1].play();
                     addChild(this._bigBugleAnimations[this._currentBigBugleType - 1]);
                     addChild(this._animationTxt);
                     this._animationTxt.text = this._currentBugle;
                     this._isplaying = true;
                     this._showTimer.addEventListener(TimerEvent.TIMER,this.__showTimer);
                     this.checkNeedTimer();
                     this.show();
                     return;
                  }
               }
               else if(this._currentBugleType == SMALL_BUGLE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.SMALL_BUGLE);
               }
               else if(this._currentBugleType == ADMIN_NOTICE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.ADMIN_NOTICE);
               }
               else if(this._currentBugleType == DEFY_AFFICHE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.DEFY_AFFICHE);
               }
               else if(this._currentBugleType == CROSS_BUGLE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.BIG_BUGLE);
               }
               else if(this._currentBugleType == CROSS_NOTICE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.CROSS_NOTICE);
               }
               this._contentTxt.text = this._currentBugle;
               this._contentTxt.mask = this._bgMask;
               this.stringSplic();
               this._isplaying = true;
               this._contentTxt.visible = true;
               this._contentTxt.y = 30;
               this._contentTxt1.y = 30;
               addEventListener(Event.ENTER_FRAME,this.moveFFT);
               this.show();
            }
            else
            {
               this.hide();
            }
         }
      }
      
      private function checkNeedTimer() : void
      {
         this._showTimer.start();
      }
      
      public function show() : void
      {
         if(StateManager.isInFight || StateManager.currentStateType == StateType.SHOP || StateManager.currentStateType == StateType.HOT_SPRING_ROOM && ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.LODING_TRAINER)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
         {
            return;
         }
         this.updatePos();
         if(this._currentBugleType == ADMIN_NOTICE)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.STAGE_TOP_LAYER,false,0,false);
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
            return;
         }
         if(SharedManager.Instance.showTopMessageBar)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.STAGE_TOP_LAYER,false,0,false);
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
         else
         {
            this.hide();
         }
      }
      
      public function updatePos() : void
      {
         if(this._currentBigBugleType == ChatData.B_BUGGLE_TYPE_NORMAL)
         {
            x = 167;
         }
         else
         {
            x = 0;
         }
         if(StateManager.currentStateType == StateType.SINGLEDUNGEON)
         {
            y = 45;
         }
         else
         {
            y = 0;
         }
      }
      
      private function removeAllBuggleAnimations() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._bigBugleAnimations.length)
         {
            if(this._bigBugleAnimations[_loc1_])
            {
               if(this._bigBugleAnimations[_loc1_].parent)
               {
                  this._bigBugleAnimations[_loc1_].parent.removeChild(this._bigBugleAnimations[_loc1_]);
               }
               this._bigBugleAnimations[_loc1_].stop();
            }
            _loc1_++;
         }
      }
      
      private function stringSplic() : void
      {
         var _loc1_:int = 0;
         if(this._contentTxt.textWidth > 535)
         {
            _loc1_ = 0;
            while(_loc1_ < this._currentBugle.length)
            {
               this._contentTxt.text = this._currentBugle.substr(0,_loc1_);
               if(this._contentTxt.textWidth >= 530)
               {
                  this._contentTxt1.text = this._currentBugle.substr(_loc1_,this._currentBugle.length - 1);
                  addChild(this._contentTxt1);
                  this._textCount = 2;
                  this._contentTxt1.visible = false;
                  this._contentTxt1.textColor = this._contentTxt.textColor;
                  this._contentTxt1.mask = this._bgMask1;
                  return;
               }
               _loc1_++;
            }
         }
         else
         {
            this._textCount = 2;
         }
      }
      
      private function moveFFT(param1:Event) : void
      {
         if(this._contentTxt && this._contentTxt1.length == 0)
         {
            --this._contentTxt.y;
            if(this._contentTxt.y == 6)
            {
               this._timer = new Timer(5000);
               this._timer.start();
               removeEventListener(Event.ENTER_FRAME,this.moveFFT);
               this._timer.addEventListener(TimerEvent.TIMER,this.stopEnterFrame);
            }
            if(this._contentTxt.y < -(this._contentTxt.textHeight + 6))
            {
               this._contentTxt.visible = false;
               this._isplaying = false;
               removeEventListener(Event.ENTER_FRAME,this.moveFFT);
               this.checkPlay();
            }
         }
         if(this._contentTxt1.length != 0)
         {
            if(this._contentTxt.visible)
            {
               --this._contentTxt.y;
            }
            if(this._contentTxt1.visible)
            {
               --this._contentTxt1.y;
            }
            if(this._contentTxt.y == 6)
            {
               this._timer = new Timer(3000);
               this._timer.start();
               removeEventListener(Event.ENTER_FRAME,this.moveFFT);
               this._timer.addEventListener(TimerEvent.TIMER,this.stopEnterFrame);
            }
            if(this._contentTxt.y < -(this._contentTxt.textHeight + 6))
            {
               this._contentTxt1.visible = true;
               this._contentTxt.visible = false;
               this._contentTxt.y = 30;
            }
            if(this._contentTxt1.y == 6)
            {
               this._timer = new Timer(3000);
               this._timer.start();
               removeEventListener(Event.ENTER_FRAME,this.moveFFT);
               this._timer.addEventListener(TimerEvent.TIMER,this.stopEnterFrame);
            }
            if(this._contentTxt1.y < -(this._contentTxt1.textHeight + 6))
            {
               this._contentTxt1.visible = false;
               this._isplaying = false;
               this._contentTxt1.text = "";
               removeEventListener(Event.ENTER_FRAME,this.moveFFT);
               this.checkPlay();
            }
         }
      }
      
      private function stopEnterFrame(param1:TimerEvent) : void
      {
         this._timer.stop();
         if(this._contentTxt.y == 6)
         {
            this._contentTxt.y -= 1;
         }
         if(this._contentTxt1.visible)
         {
            this._contentTxt1.y -= 1;
         }
         this._timer.removeEventListener(TimerEvent.TIMER,this.stopEnterFrame);
         addEventListener(Event.ENTER_FRAME,this.moveFFT);
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this.removeAllBuggleAnimations();
         if(this._animationTxt.parent)
         {
            this._animationTxt.parent.removeChild(this._animationTxt);
         }
      }
   }
}

class ChatBugleData
{
    
   
   public var content:String;
   
   public var BugleType:int;
   
   public var subBugleType:int;
   
   function ChatBugleData(param1:String, param2:int, param3:int)
   {
      super();
      this.content = param1;
      this.BugleType = param2;
      this.subBugleType = param3;
   }
}
