import React from "react";

const style = {
  ava: `text-xs font-bold text-gray-100`,
};

const Staking = () => {
  return (
    <div className="bg-red-500 h-96 ">
      <div className=" w-64 h-96 bg-gray-900 space-y-3 px-4">
        <Header />
        <Main />
      </div>
    </div>
  );
};

const Header = () => {
  return (
    <div className={style.ava}>
      <p>1 KTk = 4000$ </p>
    </div>
  );
};

const Main = () => {
  return (
    <div className=" space-y-3">
      <Circle />
      <AvailableStaked />
      <Payment />
    </div>
  );
};


const Circle =()=> {
  return (
    <div className=" rounded-full w-52 h-52 bg-white flex justify-center items-center">
      <div className="w-44 h-44 rounded-full bg-blue-500 flex justify-center items-center">
        <div className="w-36 h-36 rounded-full bg-blue-900 flex flex-col space-y-1 justify-center items-center">
          <span className="text-sm text-gray-300  ">Total Balance</span>
          <p className="text-bold text-white font-bold text-2xl">89.004</p>
          <p className="text-bold text-white text-sm uppercase self-center font-bold">
            KTK
          </p>
        </div>
      </div>
    </div>
  );
}


const AvailableStaked =()=>{
  return (
    <div className="flex space-x-6 justify-center items-center">
      <div className="space-y-1">
        <p className={style.ava}>Available</p>
        <p className={style.ava}>Staked</p>
      </div>
      <div className="space-y-1">
        <p className={style.ava}>18.1010(18%)</p>
        <p className={style.ava}>73.4910(1%)</p>
      </div>
    </div>
  );
}

const Payment = () => {
  const pop = () => {
 Swal.fire({
   title: "Buy Token",
   html: `<input type="text" id=" class="" placeholder="Enter Address">
  <input type="text" id="password" class="" placeholder="Enter Amount" >`,
  
   confirmButtonText: "Send",
 })
};
  return (
    <div className=" flex space-x-4">
      <div
        onClick={() => pop()}
        className=" px-4 py-1 bg-blue-400 rounded-lg text-gray-100 font-semibold cursor-pointer"
      >
        Buy Token
      </div>

      <div
        onClick={() => pop()}
        className=" w-24 px-[1.8rem] cursor-pointer py-1 ring-1 rounded-lg text-gray-100 font-semibold"
      >
        Stake
      </div>
    </div>
  );
};


export default Staking;
