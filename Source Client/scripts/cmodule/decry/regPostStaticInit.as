package cmodule.decry
{
   public function regPostStaticInit(param1:Function) : void
   {
      if(!gpostStaticInits)
      {
         gpostStaticInits = [];
      }
      gpostStaticInits.push(param1);
   }
}
