type T1 = { name: string };
type T2 = { age: number };
type T3 = T1 & T2;

declare const UserIdBrand: unique symbol;
type UserId = string & { readonly [UserIdBrand]: typeof UserIdBrand };

let answer : string = 42 as unknown as string;

let user: UserId = validateUserId("some-id");
let value: string = user;

function validateUserId(str: string): UserId {
    // if (is_valid_user_id(str)) ...
    return str as UserId;
}




// function getId(id: UserId): string {
//     return id;
// }


// let x = "some-id" as UserId;
// getId(x);