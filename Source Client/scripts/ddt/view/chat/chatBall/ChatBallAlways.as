package ddt.view.chat.chatBall
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.geom.Point;
   
   public class ChatBallAlways extends ChatBallBase
   {
       
      
      public function ChatBallAlways()
      {
         super();
         this.init();
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      private function init() : void
      {
         _field = new ChatBallTextAreaPlayer();
      }
      
      override protected function get field() : ChatBallTextAreaBase
      {
         return _field;
      }
      
      override public function setText(param1:String, param2:int = 0) : void
      {
         clear();
         if(!paopaoMC)
         {
            this.newPaopao();
         }
         var _loc3_:int = this.globalToLocal(new Point(500,10)).x;
         this.field.x = _loc3_ < 0 ? Number(0) : Number(_loc3_);
         this.field.text = param1;
         fitSize(this.field);
         this.show();
      }
      
      override public function show() : void
      {
         super.show();
      }
      
      override public function hide() : void
      {
         super.hide();
         if(this.field && this.field.parent)
         {
            this.field.parent.removeChild(this.field);
         }
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
      }
      
      private function newPaopao() : void
      {
         if(paopao)
         {
            removeChild(paopao);
         }
         paopaoMC = ComponentFactory.Instance.creat("ChatBall16000");
         _chatballBackground = new ChatBallBackground(paopaoMC);
         addChild(paopao);
      }
      
      public function setBGDirection(param1:int) : void
      {
         _chatballBackground.scaleX = param1;
         fitSize(this.field);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
