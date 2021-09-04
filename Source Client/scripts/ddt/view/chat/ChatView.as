package ddt.view.chat
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   use namespace chat_system;
   
   public class ChatView extends Sprite
   {
       
      
      private var _input:ChatInputView;
      
      private var _output:ChatOutputView;
      
      private var _state:int = -1;
      
      private var _stateArr:Vector.<ChatViewInfo>;
      
      private var _bg:Image;
      
      private var _slideBtn:ScaleFrameImage;
      
      private var _slideBtnUpPos1:Point;
      
      private var _slideBtnDownPos1:Point;
      
      private var _slideViewUpPos1:Point;
      
      private var _slideViewDownPos1:Point;
      
      private var _slideBtnUpPos2:Point;
      
      private var _slideBtnDownPos2:Point;
      
      private var _slideViewUpPos2:Point;
      
      private var _slideViewDownPos2:Point;
      
      private var _slideBtnUpPos3:Point;
      
      private var _slideBtnDownPos3:Point;
      
      private var _slideViewUpPos3:Point;
      
      private var _slideViewDownPos3:Point;
      
      private var _currentType:Boolean = true;
      
      private var _canSlide:Boolean = true;
      
      private var _lockSlide:Boolean = false;
      
      private var _shine:Boolean = false;
      
      public function ChatView()
      {
         super();
         this.init();
         this.intEvent();
      }
      
      public function get input() : ChatInputView
      {
         return this._input;
      }
      
      public function get output() : ChatOutputView
      {
         return this._output;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set currentType(param1:Boolean) : void
      {
         if(this._currentType == param1)
         {
            return;
         }
         this._currentType = param1;
         if(this._state == 29 || this._state == 12 || this._state == 13 || this._state == 28)
         {
            SharedManager.Instance.setChatOutPutType(this._state,this._currentType);
         }
         if(this._currentType)
         {
            this.showView();
         }
         else
         {
            this.hideView();
         }
         this.setBtnFrame(this._currentType);
      }
      
      public function get currentType() : Boolean
      {
         return this._currentType;
      }
      
      public function get canSlide() : Boolean
      {
         return this._canSlide;
      }
      
      public function get lockSlide() : Boolean
      {
         return this._lockSlide;
      }
      
      public function setSlideBtnEnable(param1:Boolean) : void
      {
         this._slideBtn.buttonMode = param1;
         this._slideBtn.mouseEnabled = param1;
         if(param1)
         {
            this._slideBtn.filters = null;
         }
         else
         {
            this._slideBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function setSlideBtnVisible(param1:Boolean) : void
      {
         if(this.state != ChatManager.CHAT_GAME_STATE && ChatManager.Instance.state != ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            this._slideBtn.visible = param1;
         }
      }
      
      private function showView() : void
      {
         var _loc1_:Point = new Point();
         var _loc2_:Point = new Point();
         if(this.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            _loc1_ = this._slideViewUpPos3;
            _loc2_ = this._slideBtnUpPos3;
            this.slideUpObjectEase(this._slideBtn,_loc2_);
            this.slideUpObjectEase(this.output,_loc1_);
         }
         else if(this.state != ChatManager.CHAT_GAME_STATE && this.state != ChatManager.CHAT_GAMEOVER_STATE)
         {
            _loc1_ = this._slideViewUpPos1;
            _loc2_ = this._slideBtnUpPos1;
            this.slideUpObjectEase(this._slideBtn,_loc2_,true);
            this.slideUpObjectEase(this.output,_loc1_,true);
         }
         else
         {
            _loc1_ = this._slideViewUpPos2;
            _loc2_ = this._slideBtnUpPos2;
            this.slideUpObjectEase(this._slideBtn,_loc2_);
            this.slideUpObjectEase(this.output,_loc1_);
         }
      }
      
      private function hideView() : void
      {
         var _loc1_:Point = new Point();
         var _loc2_:Point = new Point();
         if(this.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            _loc1_ = this._slideViewDownPos3;
            _loc2_ = this._slideBtnDownPos3;
            this.slideDownObject(this.output,_loc1_);
         }
         else if(this.state != ChatManager.CHAT_GAME_STATE && this.state != ChatManager.CHAT_GAMEOVER_STATE)
         {
            _loc1_ = this._slideViewDownPos1;
            _loc2_ = this._slideBtnDownPos1;
            this.slideDownObject(this.output,_loc1_,true);
         }
         else
         {
            _loc1_ = this._slideViewDownPos2;
            _loc2_ = this._slideBtnDownPos2;
            this.slideDownObject(this.output,_loc1_);
         }
         this.slideDownObject(this._slideBtn,_loc2_);
      }
      
      private function slideUpObjectEase(param1:Object, param2:Point, param3:Boolean = false) : void
      {
         if(param3)
         {
            param1.visible = true;
            TweenLite.to(param1,0.5,{
               "x":param2.x,
               "y":param2.y,
               "ease":Back.easeOut,
               "alpha":1
            });
         }
         else
         {
            TweenLite.to(param1,0.5,{
               "x":param2.x,
               "y":param2.y,
               "ease":Back.easeOut,
               "onComplete":this.buttonHideShine
            });
         }
      }
      
      private function slideDownObject(param1:Object, param2:Point, param3:Boolean = false) : void
      {
         if(param3 == true)
         {
            TweenLite.to(param1,0.5,{
               "x":param2.x,
               "y":param2.y,
               "alpha":0,
               "visible":0
            });
         }
         else
         {
            TweenLite.to(param1,0.5,{
               "x":param2.x,
               "y":param2.y
            });
         }
      }
      
      private function setBtnFrame(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._state == ChatManager.CHAT_GAME_STATE || this._state == ChatManager.CHAT_GAMEOVER_STATE || ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
            {
               this._slideBtn.setFrame(3);
            }
            else
            {
               this._slideBtn.setFrame(1);
            }
         }
         else if(this._state == ChatManager.CHAT_GAME_STATE || this._state == ChatManager.CHAT_GAMEOVER_STATE || ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            this._slideBtn.setFrame(4);
         }
         else
         {
            this._slideBtn.setFrame(2);
         }
      }
      
      private function removeTweenLite() : void
      {
         TweenLite.killTweensOf(this.output);
         TweenLite.killTweensOf(this._slideBtn);
      }
      
      private function updateViewState(param1:int) : void
      {
         this.removeTweenLite();
         if(param1 == ChatManager.CHAT_TRAINER_STATE)
         {
            ChatManager.Instance.view.parent.removeChild(ChatManager.Instance.view);
         }
         if(param1 != ChatManager.CHAT_GAMEOVER_STATE)
         {
            if(this._stateArr[param1].inputVisible)
            {
               addChild(this._input);
            }
            else if(this._input.parent)
            {
               this._input.parent.removeChild(this._input);
            }
         }
         this._input.faceEnabled = this._stateArr[param1].inputFaceEnabled;
         this._input.x = this._stateArr[param1].inputX;
         this._input.y = this._stateArr[param1].inputY;
         this._input._imBtnInGame.enable = false;
         this._input._imBtnInGame.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(SavePointManager.Instance.savePoints[13])
         {
            this._input._imBtnInGame.enable = true;
            this._input._imBtnInGame.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         ChatManager.Instance.visibleSwitchEnable = this._stateArr[param1].inputVisibleSwitchEnabled;
         if(this._state == ChatManager.CHAT_GAME_STATE || this._state == ChatManager.CHAT_GAMEOVER_STATE || ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            this._input.enableGameState = true;
            this._output.enableGameState = true;
            this._output.functionEnabled = false;
         }
         else
         {
            this._input.enableGameState = false;
            this._output.enableGameState = false;
         }
         this._output.bg = this._stateArr[param1].outputBackground;
         this._output.lockEnable = this._stateArr[param1].outputLockEnabled;
         this._output.isLock = this._stateArr[param1].outputIsLock;
         this._output.contentField.style = this._stateArr[param1].outputContentFieldStyle;
         if(this._stateArr[param1].outputChannel != -1)
         {
            this._output.channel = this._stateArr[param1].outputChannel;
         }
         if(this._currentType)
         {
            this._output.x = this._stateArr[param1].outputX;
            this._output.y = this._stateArr[param1].outputY;
         }
         this._canSlide = this._stateArr[param1].outputLockEnabled;
         this.setSlideBtnEnable(this._canSlide);
         if(this._canSlide)
         {
            this._currentType = this._stateArr[param1].slide;
            if(SharedManager.Instance.chatOutPutType[param1] != null)
            {
               this._currentType = SharedManager.Instance.chatOutPutType[param1];
            }
            this.reintOutView();
            this._slideBtn.visible = !this._output.isLock;
         }
         else if(this.state != ChatManager.CHAT_GAME_LOADING && this.state != ChatManager.CHAT_ROOM_STATE)
         {
            PositionUtils.setPos(this._output,this._slideViewUpPos1);
            PositionUtils.setPos(this._slideBtn,this._slideBtnUpPos1);
            this._output.alpha = 1;
            this._output.visible = true;
            this._slideBtn.visible = !this._output.isLock;
         }
         else
         {
            this._output.x = this._stateArr[param1].outputX;
            this._output.y = this._stateArr[param1].outputY;
            this._output.alpha = 1;
            this._output.visible = true;
            this._slideBtn.visible = this._output.isLock;
         }
         this.setBtnFrame(this._currentType);
         this._output.updateCurrnetChannel();
      }
      
      private function reintOutView() : void
      {
         this.setShowBtnPos();
         if(this._currentType)
         {
            this._output.alpha = 1;
            this._output.visible = true;
         }
         else
         {
            this._output.alpha = 0;
            this._output.visible = false;
         }
      }
      
      public function set state(param1:int) : void
      {
         if(this._state == param1 && this._state != ChatManager.CHAT_WORLDBOS_ROOM && this._state != ChatManager.CHAT_CONSORTIA_VIEW && this._state != ChatManager.CHAT_CONSORTIA_TRANSPORT_VIEW)
         {
            return;
         }
         if(param1 == ChatManager.CHAT_GAME_STATE || param1 == ChatManager.CHAT_GAMEOVER_STATE || ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            this._slideBtn.alpha = 0.5;
         }
         else
         {
            this._slideBtn.alpha = 1;
         }
         this._lockSlide = true;
         this._canSlide = true;
         var _loc2_:int = this._state;
         this._state = param1;
         this._output.contentField.contentWidth = ChatOutputField.NORMAL_WIDTH;
         ChatManager.Instance.setFocus();
         this._input.hidePanel();
         this.updateViewState(this._state);
         this._output.setChannelBtnVisible(!this._output.isLock);
         this._output.setLockBtnTipData(this._output.isLock);
         this.buttonHideShine();
         this._lockSlide = false;
      }
      
      private function setShowBtnPos() : void
      {
         if(this.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            PositionUtils.setPos(this._output,this._slideViewUpPos3);
            PositionUtils.setPos(this._slideBtn,this._slideBtnUpPos3);
         }
         else if(this.state != ChatManager.CHAT_GAME_STATE && this.state != ChatManager.CHAT_GAMEOVER_STATE)
         {
            if(this._currentType)
            {
               PositionUtils.setPos(this._output,this._slideViewUpPos1);
               PositionUtils.setPos(this._slideBtn,this._slideBtnUpPos1);
            }
            else
            {
               PositionUtils.setPos(this._output,this._slideViewDownPos1);
               PositionUtils.setPos(this._slideBtn,this._slideBtnDownPos1);
            }
         }
         else if(this.state != ChatManager.CHAT_GAME_LOADING && this.state != ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            PositionUtils.setPos(this._output,this._slideViewUpPos2);
            PositionUtils.setPos(this._slideBtn,this._slideBtnUpPos2);
         }
      }
      
      public function set bg(param1:Boolean) : void
      {
         if(param1)
         {
            this._bg.visible = true;
         }
         else
         {
            this._bg.visible = false;
         }
      }
      
      private function init() : void
      {
         var _loc2_:ChatViewInfo = null;
         var _loc3_:XML = null;
         this._input = ComponentFactory.Instance.creatCustomObject("chat.InputView");
         this._output = ComponentFactory.Instance.creatCustomObject("chat.OutputView");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.ChatViewBg");
         this._slideBtn = ComponentFactory.Instance.creatComponentByStylename("chat.viewSlideBtn");
         this._slideBtn.buttonMode = true;
         this._slideBtn.setFrame(1);
         this._slideBtnUpPos1 = ComponentFactory.Instance.creatCustomObject("chat.viewSlideBtn.upPos1");
         this._slideBtnDownPos1 = ComponentFactory.Instance.creatCustomObject("chat.viewSlideBtn.downPos1");
         this._slideViewUpPos1 = ComponentFactory.Instance.creatCustomObject("chat.viewSlide.upPos1");
         this._slideViewDownPos1 = ComponentFactory.Instance.creatCustomObject("chat.viewSlide.downPos1");
         this._slideBtnUpPos2 = ComponentFactory.Instance.creatCustomObject("chat.viewSlideBtn.upPos2");
         this._slideBtnDownPos2 = ComponentFactory.Instance.creatCustomObject("chat.viewSlideBtn.downPos2");
         this._slideViewUpPos2 = ComponentFactory.Instance.creatCustomObject("chat.viewSlide.upPos2");
         this._slideViewDownPos2 = ComponentFactory.Instance.creatCustomObject("chat.viewSlide.downPos2");
         this._slideBtnUpPos3 = ComponentFactory.Instance.creatCustomObject("chat.viewSlideBtn.upPos3");
         this._slideBtnDownPos3 = ComponentFactory.Instance.creatCustomObject("chat.viewSlideBtn.downPos3");
         this._slideViewUpPos3 = ComponentFactory.Instance.creatCustomObject("chat.viewSlide.upPos3");
         this._slideViewDownPos3 = ComponentFactory.Instance.creatCustomObject("chat.viewSlide.downPos3");
         this._stateArr = new Vector.<ChatViewInfo>();
         var _loc1_:int = 0;
         while(_loc1_ <= 30)
         {
            _loc2_ = new ChatViewInfo();
            _loc3_ = ComponentFactory.Instance.getCustomStyle("chatViewInfo.state_" + String(_loc1_));
            if(!_loc3_)
            {
               this._stateArr.push(_loc2_);
            }
            else
            {
               ObjectUtils.copyPorpertiesByXML(_loc2_,_loc3_);
               this._stateArr.push(_loc2_);
            }
            _loc1_++;
         }
         this._bg.visible = false;
         addChild(this._bg);
         addChild(this._output);
         addChild(this._input);
         addChild(this._slideBtn);
      }
      
      private function intEvent() : void
      {
         this._slideBtn.addEventListener(MouseEvent.CLICK,this.__slideChatView);
         ChatManager.Instance.model.addEventListener(ChatEvent.BUTTON_SHINE,this.__buttonShine);
         this._slideBtn.addEventListener(MouseEvent.ROLL_OVER,this.__outputOver);
         this._slideBtn.addEventListener(MouseEvent.ROLL_OUT,this.__outputOut);
         this._output.addEventListener(MouseEvent.ROLL_OVER,this.__outputOver);
         this._output.addEventListener(MouseEvent.ROLL_OUT,this.__outputOut);
      }
      
      private function __outputOver(param1:MouseEvent) : void
      {
         if(this.state == ChatManager.CHAT_GAME_STATE || this.state == ChatManager.CHAT_GAMEOVER_STATE || ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            this._slideBtn.alpha = 1;
         }
      }
      
      private function __outputOut(param1:MouseEvent) : void
      {
         if(this.state == ChatManager.CHAT_GAME_STATE || this.state == ChatManager.CHAT_GAMEOVER_STATE || ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            this._slideBtn.alpha = 0.5;
         }
      }
      
      private function __slideChatView(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.currentType = !this._currentType;
         this._canSlide = false;
      }
      
      private function __buttonShine(param1:ChatEvent) : void
      {
         if(this._currentType == false && this.state == ChatManager.CHAT_GAME_STATE || this.state == ChatManager.CHAT_GAMEOVER_STATE || ChatManager.Instance.state == ChatManager.CHAT_MULTI_SHOOT_GAME_STATE)
         {
            this.buttonShowShine();
         }
      }
      
      private function buttonShowShine() : void
      {
         this._shine = true;
         TweenMax.to(this._slideBtn,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3,
               "inner":true
            }
         });
      }
      
      private function buttonHideShine() : void
      {
         if(!this._shine)
         {
            return;
         }
         TweenMax.killChildTweensOf(this._slideBtn.parent,false);
         this._slideBtn.filters = null;
         this._shine = false;
      }
   }
}
