package worldboss.player
{
   public class RankingPersonInfo
   {
       
      
      private var _userId:int;
      
      private var _id:int;
      
      private var _name:String;
      
      private var _damage:int;
      
      private var _percentage:Number;
      
      private var _isVip:Boolean;
      
      private var _typeVip:int;
      
      private var _point:int;
      
      private var _nickName:String;
      
      public function RankingPersonInfo()
      {
         super();
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function set userId(param1:int) : void
      {
         this._userId = param1;
      }
      
      public function get point() : int
      {
         return this._point;
      }
      
      public function set point(param1:int) : void
      {
         this._point = param1;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function set nickName(param1:String) : void
      {
         this._nickName = param1;
      }
      
      public function set typeVip(param1:int) : void
      {
         this._typeVip = param1;
      }
      
      public function get typeVip() : int
      {
         return this._typeVip;
      }
      
      public function get isVip() : Boolean
      {
         return this._isVip;
      }
      
      public function set isVip(param1:Boolean) : void
      {
         this._isVip = param1;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set damage(param1:int) : void
      {
         this._damage = param1;
      }
      
      public function get damage() : int
      {
         return this._damage;
      }
      
      public function set percentage(param1:Number) : void
      {
         this._percentage = param1;
      }
      
      public function get percentage() : Number
      {
         return this._percentage;
      }
      
      public function getPercentage(param1:Number) : String
      {
         if(this._damage >= param1)
         {
            return "100%";
         }
         return (this._damage / param1 * 100).toString().substr(0,5) + "%";
      }
   }
}
