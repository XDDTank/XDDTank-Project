package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   
   public class QuestStarListView extends Component
   {
       
      
      private var _level:int;
      
      private var _starContainer:HBox;
      
      private var _starImg:Vector.<ScaleFrameImage>;
      
      private var _lightMovie:MovieClip;
      
      public function QuestStarListView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._starContainer = new HBox();
         addChild(this._starContainer);
         this._starImg = new Vector.<ScaleFrameImage>(5);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._starImg[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("quest.complete.star");
            _loc1_++;
         }
         this._lightMovie = ComponentFactory.Instance.creat("asset.core.improveEffect");
      }
      
      public function level(param1:int, param2:Boolean = false) : void
      {
         if(param1 > 5 || param1 < 0)
         {
            return;
         }
         this._level = param1;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            if(this._level > _loc3_)
            {
               if(param2 && this._level - 1 == _loc3_)
               {
                  this._starContainer.addChild(this._lightMovie);
                  this._lightMovie.play();
               }
               else
               {
                  this._starContainer.addChild(this._starImg[_loc3_]);
                  this._starImg[_loc3_].setFrame(2);
               }
            }
            else
            {
               this._starContainer.addChild(this._starImg[_loc3_]);
               this._starImg[_loc3_].setFrame(1);
            }
            _loc3_++;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         super.dispose();
         if(this._starContainer)
         {
            ObjectUtils.disposeObject(this._starContainer);
         }
         this._starContainer = null;
         if(this._lightMovie)
         {
            ObjectUtils.disposeObject(this._lightMovie);
         }
         this._lightMovie = null;
         if(this._starImg)
         {
            _loc1_ = 0;
            while(_loc1_ < 5)
            {
               if(this._starImg[_loc1_])
               {
                  ObjectUtils.disposeObject(this._starImg[_loc1_]);
               }
               this._starImg[_loc1_] = null;
               _loc1_++;
            }
         }
         if(this._starImg)
         {
            ObjectUtils.disposeObject(this._starImg);
         }
         this._starImg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
